import json

f = open('course_credits.json')
data = json.load(f)

subs = {}
tc = 0
for k, v in data.items():
    for k1, v1 in v.items():
        for k2, v2 in v1.items():
            # print(k2)
            # print(v2)
            subs[k2] = v2
            tc += 1
    #         break
    #     break
    # break

print(tc)
print(len(subs))
# print(subs)

with open("subs.json", "w") as file:
    json.dump(subs, file,indent=2)