import time
import random

def mk_row():
    return f"{random.uniform(0, 10)},{random.uniform(30, 50)},{random.uniform(0, 0.5)},{random.uniform(0, 360)}"

def update(data):
    data.pop(0)
    data.append(mk_row())

data = [mk_row() for _ in range(10)]

while True:
    time.sleep(1)
    update(data)
    with open("./ruby_on_rails_app/app/assets/chart_data.txt", "w") as f:
        data_str = ""
        for row in data:
            data_str += f"{row}\n"
        f.write(data_str)