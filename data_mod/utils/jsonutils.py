from . import log4p
from .typeutils import is_list_of_objects

import ntpath

logger = log4p.createLogger(ntpath.basename(__file__))

JSON_PATH_SEPARATOR = '.'

def scan_tree(tree, path, flat_tree):
    """Recursively scan a (JSON) tree structure to return a 'flatten' form of the tree. Caveat: array of objects
    will get flatten appropriately. But array of array will get treated as primitive. In other words array of array
    will not get further flatten."""
    # TODO: I am here - The primitive string is not properly quoted in the output
    if not isinstance(tree, dict):
        flat_tree[path] = tree
        return
    for k, v in tree.items():
        if isinstance(v, dict):
            is_leaf = len(v.items()) == 0
            if not is_leaf:
                scan_tree(v, path + JSON_PATH_SEPARATOR + k, flat_tree)
        elif is_list_of_objects(v):
            index = 0
            for item in v:
                apath = '%s%s%s[%d]' %(path, JSON_PATH_SEPARATOR, k, index)
                scan_tree(item, apath, flat_tree)
                index += 1
        else:
            logger.debug('{%s : %s}' %(path + JSON_PATH_SEPARATOR + k, v))
            # if isinstance(v, str):
            #     v = '"%s"' %(v)
            flat_tree[path + JSON_PATH_SEPARATOR + k] = v

# TODO: This starts failing when there is array involved! What do we do if there is an array involved?
def flatten_tree(json_file):
    """Read a file in JSON format and return a flatten content of the data."""
    with open(json_file) as f:
        return flatten_json_string(f.read())

def flatten_json_string(json_str):
    ret_map = {}
    the_tree = eval(json_str)
    scan_tree(the_tree, '', ret_map)
    return ret_map