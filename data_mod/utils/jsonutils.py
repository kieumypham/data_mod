from . import log4p
from . import typeutils

import ntpath

logger = log4p.createLogger(ntpath.basename(__file__))

JSON_PATH_SEPARATOR = '.'

def build_path(path, k, index = None):
    if index is None:
        return path + JSON_PATH_SEPARATOR + k if path else k
    return '%s%s%s[%d]' %(path, JSON_PATH_SEPARATOR, k, index) if path else '%s[%d]' %(k, index)

def scan_tree(tree, path, flat_tree):
    """Recursively scan a (JSON) tree structure to return a 'flatten' form of the tree. Caveat: array of objects
    will get flatten appropriately. But array of array will get treated as primitive. In other words array of array
    will not get further flatten."""
    if not isinstance(tree, dict):
        flat_tree[path] = tree
        return
    for k, v in tree.items():
        if isinstance(v, dict):
            is_leaf = len(v.items()) == 0
            if not is_leaf:
                scan_tree(v, build_path(path, k), flat_tree)
        elif typeutils.is_list_of_objects(v):
            index = 0
            for item in v:
                scan_tree(item, build_path(path, k, index), flat_tree)
                index += 1
        else:
            flat_tree[build_path(path, k)] = v

def flatten_tree(json_file):
    """Read a file in JSON format and return a flatten content of the data."""
    with open(json_file) as f:
        return flatten_json_string(f.read())

def flatten_json_string(json_str):
    ret_map = {}
    the_tree = eval(json_str)
    scan_tree(the_tree, '', ret_map)
    return ret_map