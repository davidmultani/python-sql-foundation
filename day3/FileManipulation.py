CleanedText = ''
with open('./day3/DemoText.txt', 'r') as f:
    text = f.read()
    CleanedText = ' '.join(text.split())
    CleanedText = CleanedText.lower()

with open('./day3/CleanedText.txt', 'w') as f:
    f.write(CleanedText)
