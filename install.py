import json

def getProfiles(data):
    profiles=[]

    for i in data['profiles']:
        profiles.append(i)

    return profiles

def enumerateArray(data, startingX):
    x = startingX 
    for i in data:
        print("{0}) {1}".format(x,i))
        x += 1

def getJsonFromFile(fileName):
    with open(fileName) as file:
        if not file.closed:
            data = json.load(file)
            file.close()

            return data

    raise FileNotFoundError("There was an error while opening the file, it may be in use")

    return

try: 
    data = getJsonFromFile('config_profiles.json')

except FileNotFoundError as e:
    print(e)
    exit()

print("\nPlease Choose a Profile: \n")

profiles = getProfiles(data) 

enumerateArray(profiles, 1)

profileNum = int(input("> ")) - 1

profile = profiles[profileNum]

configs = data['profiles'][profile]

keys = []
for i in configs:
    keys.append(i)

for i in keys:
    print("Copying: '{0}' to '{1}'".format(i, configs[i]))




