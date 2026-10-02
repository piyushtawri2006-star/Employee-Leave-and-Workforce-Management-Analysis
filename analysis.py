import mysql.connector
import pandas as pd

config = {'host':'localhost','user':'root','password':'','database':'workforce_db'}

conn = mysql.connector.connect(**config)

employees = pd.read_sql('SELECT * FROM employees', conn)
leaves = pd.read_sql('SELECT * FROM leave_requests', conn)
attendance = pd.read_sql('SELECT * FROM attendance', conn)

print('\nEMPLOYEE SUMMARY')
print('Total employees:', len(employees))
print('Average salary:', round(employees['salary'].mean(), 2))

print('\nLEAVE SUMMARY')
print(leaves['status'].value_counts())

print('\nATTENDANCE SUMMARY')
attendance['present'] = (attendance['status'] == 'Present').astype(int)
print('Overall attendance %:', round(attendance['present'].mean()*100, 2))

conn.close()
