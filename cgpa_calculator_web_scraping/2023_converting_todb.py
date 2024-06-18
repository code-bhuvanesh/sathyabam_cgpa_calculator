import pickle5 as pickle

all_tables = []
all_subs = []

print("start")

with open("all_subs.pkl", "rb") as file:
    print("1")
    all_subs = pickle.load(file)
# print(all_subs)
with open("all_tables.pkl", "rb") as file:
    print("2")
    all_tables = pickle.load(file)

for table, sub in zip(all_tables, all_subs):
    print(table)
    print(sub)
