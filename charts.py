import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

config = {'host':'localhost','user':'root','password':'','database':'workforce_db'}
conn = mysql.connector.connect(**config)

df = pd.read_sql('''
SELECT d.department_name, COUNT(e.employee_id) employee_count
FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
GROUP BY d.department_id,d.department_name
''', conn)

Path('analytics/output').mkdir(parents=True, exist_ok=True)
df.plot(kind='bar', x='department_name', y='employee_count', legend=False, title='Employees by Department')
plt.tight_layout()
plt.savefig('analytics/output/employees_by_department.png')
plt.close()
conn.close()
print('Chart saved to analytics/output/employees_by_department.png')
