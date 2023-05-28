# ---------------------------------
# file combiner
# don't know what the fuck is going on in this but it works so im not complaining
# it doesnt work fuck
# ---------------------------------

#-------------------------
# Imports
#-------------------------
import json
import time
import os

#-------------------------
# Variables
#-------------------------
before = ".."
file =  "workspace_config.json"

#-------------------------
# Functions
#-------------------------
def get(key):
    content = {}

    with open(file, "r") as f:
        content: dict = json.loads(f.read())
        
    return content.get(key, False)

def iterateFolder(folder: str, exceptions: list = []):
    if folder in exceptions:
        return []
    
    content = []

    for item in os.listdir(folder):
        if item in exceptions:
            continue
        
        print(f"scanning {item} of folder {folder}")
        full = os.path.splitext(item)

        if full[1] == "":
            print("item is folder")
            # folder
            content.extend(iterateFolder(f"{folder}/{item}", exceptions))
        elif item.endswith(".lua"):
            print("item is .lua")
            # file
            with open(f"{folder}/{item}", "r") as f:
                fileContent = f.readlines()
                formattedContent = "".join(fileContent)
                content.append(f"\n\n-----------------\n-- [Library | Folder: {folder}] {item}\n-----------------\n{formattedContent}")
        else:     
            print("item is not right type")
            print("----")

    return content

def combineFiles(exceptions: list, main: str, dump: str, files: list):
    # setup
    exceptions.append(dump)
    exceptions.append(main)
    exceptions.append("combine")
    exceptions.extend(files)

    contentFromFiles = []
    
    # files
    for i in files:
        with open(f"{before}/{i}", "r") as f:
            contentFromFiles.append(f"\n\n-----------------\n-- [Library | File] {i}\n-----------------\n{f.read()}")
    
    # all folders and contents apart from exceptions
    print("==================\n" * 3)
    foldersContents = iterateFolder(before, exceptions)
    contentFromFiles.extend(foldersContents)
           
    # main file 
    with open(f"{before}/{main}", "r") as f:
        contentFromFiles.append (f"\n\n-----------------\n-- [Main File] {main}\n-----------------\n" + f.read())
        
    # dump into dump file
    with open(f"{before}/{dump}", "w") as f:
        f.write("".join(contentFromFiles))

    return contentFromFiles

#-------------------------
# Main
#-------------------------
while True:
    time.sleep(3)
    
    # print("----- Combining files...")
    
    exceptions = get("exceptions")
    main = get("main")
    dump = get("dump")
    files = get("files")

    print(len(combineFiles(exceptions, main, dump, files)))

    # print(f"     \_____Successfully combined stuffs.")