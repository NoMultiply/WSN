import random

result = []

for i in range(2000):
    result.append(random.randint(0,5000))

print(result)
num = sorted(result);
print(sum(result), min(result), max(result), sum(result) / 2000, (num[999] + num[1000]) / 2)
