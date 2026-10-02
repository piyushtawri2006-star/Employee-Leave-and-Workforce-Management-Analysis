# AI/ML Component

Model: Logistic Regression

Target:
- 0 = Unlikely to take leave
- 1 = Likely to take leave

Features:
1. Attendance percentage
2. Previous leave count
3. Experience in years
4. Workload score
5. Department code

Run:
python ml/train_model.py

The generated `model.pkl` is used by Flask `/prediction`.
