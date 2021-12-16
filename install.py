import json
from shutil import copy
from os.path import expanduser, expandvars, normcase
from typing import List, Dict

def getListOfProfiles(data: Dict[str, str]) -> List[str]:
    '''
    Returns a list of keys from the input dictionary corresponding to the config profiles.
        
        Parameters:
            data (Dict[str, str]): A dictionary representing JSON data

        Returns:
            profiles (List[str]): A list containing the set of profiles present in the dictionary
    '''

    profiles: List[str] = []

    for i in data['profiles']:
        profiles.append(i)

    return profiles

def enumerateArray(data: Dict[str, str], startingX: int) -> None:
    '''
    Enumerates and prints a dictionary to stdout.

        Parameters:
            data (Dict[str,str]): A dictionary representing JSON data
            startingX (int): An integer representing the number to start enumerating from

        Returns:
            Nothing
    '''

    x: int = startingX 
    for i in data:
        print("{0}) {1}".format(x,i))
        x += 1

def getJsonDataFromFile(fileName: str) -> Dict[str, str]:
    '''
    Opens the provided file and loads the JSON data into a Dictionary

        Parameters:
            fileName (str): A string representing the path to the file

        Returns
            data (Dict[str, str]): A dictionary containing the JSON data from the provided file 
    '''

    with open(fileName) as file:
        if not file.closed:
            data: Dict[str, str] = json.load(file)
            file.close()

            return data

    raise FileNotFoundError("There was an error while opening the file, it may be in use")

    return

def expandPath(path: str) -> str:
    '''
    Cleans a provided file path, expanding the user directory, expanding variables, and normalizing the path case

        Parameters:
            path (str): A path to be cleaned

        Returns
            path (str): A clean version of the initially passed path
    '''

    path:str = expanduser(path)
    path:str = expandvars(path)
    path:str = normcase(path)
    return path

def copyFiles(keys: List[str], configs: Dict[str, str]) -> None:
    '''
    Copies files provided in "keys" to the corresponding path in config[key].

    Cleans paths before copying using the expandPath method.
    Also prints files being copied and intended path to stdOut

        Parameters:
            keys (List[str]): A list of filenames to copy.
            configs (Dict[str, str]): A dictionary containing the path to copy files to where keys are the file name to copy.

        Returns
            None
    '''

    for i in keys:
        print("Copying: '{0}' to '{1}'".format(i, expandPath(configs[i])))
        copy(i, expandPath(configs[i]))

def getIntegerInput(prompt: str) -> int:
    number: int = int(input(prompt))
    return number 

def handleGetJsonDataFromFile(file: str) -> Dict[str, str]:
    try: 
        data: Dict[str, str] = getJsonFromFile(file)

    except FileNotFoundError as e:
        print(e)
        exit()

    return data

def selectProfileNum(data: Dict[str, str]) -> int:
    print("\nPlease Choose a Profile: \n")

    profiles: List[str] = getListOfProfiles(data)

    enumerateArray(profiles, 1)

    profileNum: int = getIntegerInput("> ") - 1

    return profileNum


def getSelectedProfile(profileNum: int, data: Dict[str, str]) -> str:

    profiles: List[str] = getListOfProfiles(data)

    profile: string = profiles[profileNum]

    return profile

def getKeys(dictionary: Dict[str, str]) -> List[str]:
    keys: List[str] = []
    for i in dictionary:
        keys.append(i)

    return keys

def getConfigs(data: Dict[str, str], profile: str) -> Dict[str, str]:
    return data['profiles'][profile]

def main() -> None:
    data: Dict[str, str] = getJsonDataFromFile('config_profiles.json')

    profileNum: int = selectProfileNum(data) 

    profile: string = getSelectedProfile(profileNum, data)

    configs: Dict[str, str] = getConfigs(data, profile) 

    keys: List[str] = getKeys(configs)

    copyFiles(keys, configs)

# Call main function at start of program
# There is no _need_ for a main function for this program, but I prefer it over unnested "global" code.
# This way I avoid unexpected/unwanted "side-effects" and code looks prettier 
if __name__ == "__main__":
    main()





