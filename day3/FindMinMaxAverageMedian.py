import statistics
NumberList = [45, 23, 67, 87, 11, 2, 34, 32, 54]
Min = NumberList[0]
Max = NumberList[0]
Sum = 0
for element in NumberList:
    if Min > element:
        Min = element
    if Max < element:
        Max = element
    Sum = Sum + element

Average = Sum/len(NumberList)
Median = statistics.median(NumberList)

print(f'The Minimum Value is - ', Min)
print(f'The Maximum Value is - ', Max)
print(f'The Average Value is - ', Average)
print(f'The Median Value is - ', Median)
