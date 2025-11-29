import csv
import json
import os
import re
os.system("clear")
# Code to read a CSV file and print the first n rows.
iterations = int(input("Enter the number of iterations "))
count = 1
OutputString = ""
with open('/Users/davinderpalsingh/python/Python_Class/.vscode/BigMartSales.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        OutputString = OutputString + str(row)
        print(row)
        count += 1
        if count == iterations:
            break
# Code to counts how many times each word appears in a string
TextFinder = input("Enter the letter to find ")
pattern = re.compile(TextFinder, re.IGNORECASE)
findings = re.finditer(pattern, OutputString)
NoOfCount = 0
for i in findings:
    NoOfCount += 1
print(NoOfCount)

# Code to converts JSON → CSV
with open('/Users/davinderpalsingh/python/Python_Class/json.json', 'r') as f:
    data = json.load(f)

with open('/Users/davinderpalsingh/python/Python_Class/.vscode/ConvertJsonToCsv.csv', 'w') as f:
    fieldnames = data[0].keys()
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(data)
