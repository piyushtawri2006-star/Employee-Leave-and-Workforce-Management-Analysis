from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
import mysql.connector
from mysql.connector import Error
import os
import joblib
from datetime import date

app = Flask(__name__)
app.secret_key = "college-project-secret"

DB_CONFIG = {
    "host": "127.0.0.1",
    "user": "root",
    "password": "root",
    "database": "workforce_db"
}

def get_db():
    return mysql.connector.connect(**DB_CONFIG)
def fetch_all(query, params=()):
    conn = get_db()
    cur = conn.cursor(dictionary=True)
    cur.execute(query, params)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows

def execute(query, params=()):
    conn = get_db()
    cur = conn.cursor()
    cur.execute(query, params)
    conn.commit()
    last_id = cur.lastrowid
    cur.close()
    conn.close()
    return last_id

@app.route("/")
def index():
    stats = {}
    try:
        stats["employees"] = fetch_all("SELECT COUNT(*) c FROM employees")[0]["c"]
        stats["departments"] = fetch_all("SELECT COUNT(*) c FROM departments")[0]["c"]
        stats["leaves"] = fetch_all("SELECT COUNT(*) c FROM leave_requests")[0]["c"]
        stats["attendance"] = fetch_all("SELECT COUNT(DISTINCT employee_id) c FROM attendance")[0]["c"]
        dept = fetch_all("""
            SELECT d.department_name, COUNT(e.employee_id) employee_count
            FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
            GROUP BY d.department_id, d.department_name
            ORDER BY employee_count DESC
        """)
        leave_status = fetch_all("""
            SELECT status, COUNT(*) count
            FROM leave_requests GROUP BY status
        """)
    except Error as e:
        return f"<h3>Database connection error</h3><p>{e}</p><p>Make sure MySQL is running and database scripts are imported.</p>"
    return render_template("index.html", stats=stats, dept=dept, leave_status=leave_status)

@app.route("/employees")
def employees():
    rows = fetch_all("""
        SELECT e.*, d.department_name
        FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id
        ORDER BY e.employee_id
    """)
    return render_template("employees.html", employees=rows)

@app.route("/employees/add", methods=["GET", "POST"])
def add_employee():
    departments = fetch_all("SELECT * FROM departments ORDER BY department_name")
    if request.method == "POST":
        execute("""INSERT INTO employees
            (employee_code,name,email,phone,gender,department_id,designation,joining_date,salary,status)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)""", (
            request.form["employee_code"], request.form["name"], request.form["email"],
            request.form["phone"], request.form["gender"], request.form["department_id"],
            request.form["designation"], request.form["joining_date"],
            request.form["salary"], request.form["status"]))
        flash("Employee added successfully.")
        return redirect(url_for("employees"))
    return render_template("add_employee.html", departments=departments)

@app.route("/employees/edit/<int:employee_id>", methods=["GET", "POST"])
def edit_employee(employee_id):
    if request.method == "POST":
        execute("""UPDATE employees SET employee_code=%s,name=%s,email=%s,phone=%s,
            gender=%s,department_id=%s,designation=%s,joining_date=%s,salary=%s,status=%s
            WHERE employee_id=%s""", (
            request.form["employee_code"], request.form["name"], request.form["email"],
            request.form["phone"], request.form["gender"], request.form["department_id"],
            request.form["designation"], request.form["joining_date"],
            request.form["salary"], request.form["status"], employee_id))
        flash("Employee updated successfully.")
        return redirect(url_for("employees"))
    employee = fetch_all("SELECT * FROM employees WHERE employee_id=%s", (employee_id,))[0]
    departments = fetch_all("SELECT * FROM departments ORDER BY department_name")
    return render_template("edit_employee.html", employee=employee, departments=departments)

@app.route("/employees/delete/<int:employee_id>", methods=["POST"])
def delete_employee(employee_id):
    execute("DELETE FROM employees WHERE employee_id=%s", (employee_id,))
    flash("Employee deleted.")
    return redirect(url_for("employees"))

@app.route("/leaves")
def leaves():
    rows = fetch_all("""
        SELECT l.*, e.name employee_name, lt.leave_type_name
        FROM leave_requests l
        JOIN employees e ON l.employee_id=e.employee_id
        JOIN leave_types lt ON l.leave_type_id=lt.leave_type_id
        ORDER BY l.leave_id DESC
    """)
    return render_template("leaves.html", leaves=rows)

@app.route("/leaves/add", methods=["GET", "POST"])
def add_leave():
    employees_list = fetch_all("SELECT employee_id,name FROM employees WHERE status='Active' ORDER BY name")
    types = fetch_all("SELECT * FROM leave_types ORDER BY leave_type_name")
    if request.method == "POST":
        start_date = request.form["start_date"]
        end_date = request.form["end_date"]
        if end_date < start_date:
            flash("End date cannot be before start date.")
            return render_template("add_leave.html", employees=employees_list, leave_types=types)
        execute("""INSERT INTO leave_requests
            (employee_id,leave_type_id,start_date,end_date,reason)
            VALUES (%s,%s,%s,%s,%s)""", (
            request.form["employee_id"], request.form["leave_type_id"],
            start_date, end_date, request.form["reason"]))
        flash("Leave request added.")
        return redirect(url_for("leaves"))
    return render_template("add_leave.html", employees=employees_list, leave_types=types)

@app.route("/leaves/status/<int:leave_id>/<status>", methods=["POST"])
def leave_status(leave_id, status):
    if status not in ("Approved", "Rejected"):
        return redirect(url_for("leaves"))
    execute("UPDATE leave_requests SET status=%s WHERE leave_id=%s", (status, leave_id))
    flash(f"Leave {status.lower()}.")
    return redirect(url_for("leaves"))

@app.route("/attendance", methods=["GET", "POST"])
def attendance():
    selected_date = request.values.get("attendance_date") or date.today().isoformat()
    leave_types = fetch_all("SELECT * FROM leave_types ORDER BY leave_type_name")

    if request.method == "POST":
        employees_list = fetch_all(
            "SELECT employee_id FROM employees WHERE status='Active' ORDER BY name"
        )
        for employee in employees_list:
            employee_id = employee["employee_id"]
            execute("""
                INSERT INTO attendance
                    (employee_id, attendance_date, status, leave_type_id, check_in, check_out)
                VALUES (%s, %s, %s, NULLIF(%s, ''), NULLIF(%s, ''), NULLIF(%s, ''))
                ON DUPLICATE KEY UPDATE
                    status=VALUES(status), leave_type_id=VALUES(leave_type_id),
                    check_in=VALUES(check_in), check_out=VALUES(check_out)
            """, (
                employee_id,
                selected_date,
                request.form.get(f"status_{employee_id}", "Absent"),
                request.form.get(f"leave_type_{employee_id}", ""),
                request.form.get(f"check_in_{employee_id}", ""),
                request.form.get(f"check_out_{employee_id}", "")))
        flash(f"Attendance saved for {selected_date}.")
        return redirect(url_for("attendance", attendance_date=selected_date))

    rows = fetch_all("""
         SELECT e.employee_id, e.name employee_name, %s attendance_date,
             a.attendance_id, a.status, a.leave_type_id, a.check_in, a.check_out
        FROM employees e
        LEFT JOIN attendance a
          ON a.employee_id=e.employee_id AND a.attendance_date=%s
        WHERE e.status='Active'
        ORDER BY e.name
    """, (selected_date, selected_date))
    return render_template("attendance.html", attendance=rows,
                           selected_date=selected_date, leave_types=leave_types)

@app.route("/departments")
def departments():
    rows = fetch_all("""
        SELECT d.*, COUNT(e.employee_id) employee_count
        FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
        GROUP BY d.department_id,d.department_name,d.location
        ORDER BY d.department_id
    """)
    return render_template("departments.html", departments=rows)

@app.route("/analytics")
def analytics():
    dept = fetch_all("""
        SELECT d.department_name, COUNT(e.employee_id) employee_count,
               COALESCE(AVG(e.salary),0) avg_salary
        FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
        GROUP BY d.department_id,d.department_name
        ORDER BY employee_count DESC
    """)
    leaves = fetch_all("""
        SELECT lt.leave_type_name,
               COALESCE(SUM(leave_data.leave_days), 0) leave_count
        FROM leave_types lt
        LEFT JOIN (
            SELECT leave_type_id, DATEDIFF(end_date, start_date) + 1 leave_days
            FROM leave_requests
            WHERE status <> 'Rejected' AND end_date >= start_date
            UNION ALL
            SELECT leave_type_id, 1 leave_days
            FROM attendance
            WHERE status='Leave' AND leave_type_id IS NOT NULL
        ) leave_data ON lt.leave_type_id=leave_data.leave_type_id
        GROUP BY lt.leave_type_id,lt.leave_type_name
    """)
    attendance = fetch_all("""
        SELECT e.name,
          ROUND(100 * SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) / NULLIF(COUNT(a.attendance_id),0),2) attendance_pct
        FROM employees e LEFT JOIN attendance a ON e.employee_id=a.employee_id
        GROUP BY e.employee_id,e.name ORDER BY attendance_pct DESC
    """)
    return render_template("analytics.html", dept=dept, leaves=leaves, attendance=attendance)

@app.route("/prediction", methods=["GET", "POST"])
def prediction():
    employees = fetch_all("SELECT employee_id, name FROM employees WHERE status='Active' ORDER BY name")
    result = None
    result_class = None
    if request.method == "POST":
        employee_id = request.form.get("employee_id")
        employee_name = "Employee"
        if employee_id:
            employee = fetch_all("SELECT name FROM employees WHERE employee_id=%s", (employee_id,))
            if employee:
                employee_name = employee[0]["name"]

        model_path = os.path.join("ml", "model.pkl")
        if not os.path.exists(model_path):
            result = f"{employee_name}: Model not found. Run: python ml/train_model.py"
            result_class = "unlikely"
        else:
            model = joblib.load(model_path)
            attendance_pct = float(request.form["attendance_pct"])
            X = [[
                attendance_pct,
                int(request.form["previous_leaves"]),
                float(request.form["experience"]),
                float(request.form["workload"]),
                int(request.form["department_code"])
            ]]
            pred = model.predict(X)[0]

            if attendance_pct < 75:
                status = "Unlikely to take leave"
                result_class = "unlikely"
            elif pred == 1:
                status = "Likely to take leave"
                result_class = "likely"
            else:
                status = "Unlikely to take leave"
                result_class = "unlikely"

            result = f"{employee_name}: {status}"
    return render_template("prediction.html", result=result, result_class=result_class, employees=employees)

@app.route("/api/department-data")
def department_data():
    return jsonify(fetch_all("""
        SELECT d.department_name name, COUNT(e.employee_id) value
        FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
        GROUP BY d.department_id,d.department_name
    """))

if __name__ == "__main__":
    try:
        conn = get_db()
        print("MySQL connection successful!")
        conn.close()
    except Error as e:
        print("MySQL connection failed:", e)

    app.run(debug=True)