import time
import random

def update(data):
    data.pop(0)
    data.append(random.uniform(0, 10))

data = [random.uniform(0, 10) for _ in range(10)]
while True:
    time.sleep(1)
    update(data)
    with open("./ruby_on_rails_app/app/assets/chart_data.txt", "w") as f:
        data_str = ""
        for item in data:
            data_str += f"{item}\n"
        f.write(data_str)