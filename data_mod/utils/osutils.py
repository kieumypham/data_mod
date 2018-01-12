import os
import re


def list_files_and_folders(start_dir, pattern = ''):
    """Recursively list all directories and files from start_dir, optionally match given name pattern"""
    filtered_files = []
    roots = []
    for dir, dir_names, file_names in os.walk(start_dir):
        roots.append(dir)
        for f in file_names:
            if re.match(pattern, f):
                filtered_files.append(os.path.join(dir, f))

    return roots, filtered_files

# def listFilesNonRecursive(startDir, includeRegex = None):
#     onlyfiles = [f for f in listdir(startDir) if isfile(join(startDir, f))]
#     filteredFiles = [join(startDir, f) for f in onlyfiles if rex.contain(includeRegex, f)]
#     return filteredFiles
#
# def getBaseName(fileName):
#     return fileName.split(os.sep)[-1]
#
# def getBaseNameWithoutExtension(fileName):
#     extensionMarker = '.'
#     baseNameParts = getBaseName(fileName).split(extensionMarker)[:-1]
#     if len(baseNameParts) > 1:
#         return extensionMarker.join(baseNameParts)
#     else:
#         return baseNameParts[0]