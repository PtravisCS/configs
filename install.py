#!/bin/python3
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
        print("{0}) {1}".format(x, i))
        x += 1


def getJsonDataFromFile(fileName: str) -> Dict[str, str]:
    '''
    Opens the provided JSON file and loads it into a Dictionary

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

    path: str = expanduser(path)
    path: str = expandvars(path)
    path: str = normcase(path)
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
    '''
    Gets input from user and converts it to an integer.

        Parameters:
            prompt (str): The prompt to display to the user.

        Returns:
            number (int): The number returned from the user.
    '''

    number: int = int(input(prompt))
    return number 


def handleGetJsonDataFromFile(file: str) -> Dict[str, str]:
    '''
    Wraps the getJsonDataFromFile method in a try catch block.

    Gets JSON data from a file as a dictionary.

        Parameters:
            file (str): A string representing the path to file.

        Returns:
            data (Dict[str, str]): A dictionary containing the JSON data from the file
    '''

    try:
        data: Dict[str, str] = getJsonDataFromFile(file)

    except FileNotFoundError as e:
        print(e)
        exit()

    return data


def selectProfileNum(data: Dict[str, str]) -> int:
    '''
    Gets a list of profiles and prints them to screen then has the user select from them.

        Parameters:
            data (Dict[str, str]): A dictionary representing the JSON data from the config file.

        Returns:
            profileNum (in): A number representing the profile number the user selected.
    '''

    print("\nPlease Choose a Profile: \n")

    profiles: List[str] = getListOfProfiles(data)

    enumerateArray(profiles, 1)

    profileNum: int = getIntegerInput("> ") - 1

    return profileNum


def getSelectedProfile(profileNum: int, data: Dict[str, str]) -> str:

    profiles: List[str] = getListOfProfiles(data)

    profile: str = profiles[profileNum]

    return profile


def getKeys(dictionary: Dict[str, str]) -> List[str]:
    keys: List[str] = []
    for i in dictionary:
        keys.append(i)

    return keys


def getConfigs(data: Dict[str, str], profile: str) -> Dict[str, str]:
    return data['profiles'][profile]


def main() -> int:
    data: Dict[str, str] = getJsonDataFromFile('config_profiles.json')

    profileNum: int = selectProfileNum(data)

    profile: str = getSelectedProfile(profileNum, data)

    configs: Dict[str, str] = getConfigs(data, profile)

    keys: List[str] = getKeys(configs)

    copyFiles(keys, configs)

    return 0


if __name__ == "__main__":
    main()
