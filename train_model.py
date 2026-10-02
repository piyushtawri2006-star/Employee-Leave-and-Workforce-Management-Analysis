from sklearn.linear_model import LogisticRegression
import numpy as np
import joblib
from pathlib import Path

# Educational synthetic training data:
# [attendance_pct, previous_leaves, experience_years, workload_1_to_10, department_code]
X = np.array([
[98,1,5,4,1],[95,2,4,5,2],[92,1,6,6,3],[90,2,3,7,4],
[88,3,2,8,2],[85,4,1,9,4],[82,5,2,9,3],[80,5,1,10,4],
[78,6,1,9,2],[75,7,2,10,3],[97,0,8,3,1],[94,1,7,4,2],
[91,2,5,6,3],[87,3,3,7,4],[84,4,2,8,2],[81,5,1,9,4],
[96,1,9,4,1],[93,2,6,5,2],[89,3,4,7,3],[86,4,3,8,4]
])
y = np.array([0,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,0,0,1,1])

model = LogisticRegression(max_iter=1000)
model.fit(X,y)

Path(__file__).parent.mkdir(exist_ok=True)
joblib.dump(model, Path(__file__).parent/'model.pkl')
print('AI/ML model trained and saved as ml/model.pkl')
print('Training accuracy:', round(model.score(X,y)*100,2), '%')
