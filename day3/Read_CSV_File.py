import csv
with open('./day3/BigMartSales.csv', 'r') as f:
    reader = list(csv.reader(f))
    NoOfRows = len(reader) - 1
    NoOfColumns = len(reader[0])

print(f'The No. of Columns are - ', NoOfColumns,
      ' and No. of rows are - ', NoOfRows)
