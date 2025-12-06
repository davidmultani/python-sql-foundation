import json
with open('./day3/DemoJSON_File.json', 'r') as f:
    loader = json.load(f)
    ListOfDict = list(loader.items())

print(ListOfDict)
