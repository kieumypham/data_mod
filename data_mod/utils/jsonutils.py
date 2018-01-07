from . import log4p

import json
import sys
import ntpath

logger = log4p.createLogger(ntpath.basename(__file__))

JSON_PATH_SEPARATOR = '.'

def scan_tree(tree, path, flat_tree):
    """Recursively scan a (JSON) tree structure to return a 'flatten' form of the tree."""
    for k, v in tree.items():
        if isinstance(v, dict):
            is_leaf = len(v.items()) == 0
            if not is_leaf:
                scan_tree(v, path + JSON_PATH_SEPARATOR + k, flat_tree)
        else:
            logger.debug('{%s : %s}' %(path + JSON_PATH_SEPARATOR + k, v))
            flat_tree[path + JSON_PATH_SEPARATOR + k] = v

# TODO: This starts failing when there is array involved! What do we do if there is an array involved?
def flatten_tree(json_file):
    """Read a file in JSON format and return a flatten content of the data."""
    with open(json_file) as f:
        return flatten_json_string(f.read())

def flatten_json_string(json_str):
    ret_map = {}
    the_tree = eval(json_str)
    scan_tree(the_tree, '$', ret_map)
    return ret_map