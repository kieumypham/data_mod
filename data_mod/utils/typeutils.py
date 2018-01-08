primitive = (int, float, str, bool, ...)


def is_primitive(thing):
    return type(thing) in primitive

def is_list_of_objects(thing):
    """Test if a homogenous array is one which holds objects. Won't work for non-homogenous array."""
    return isinstance(thing, list) and len(thing) > 0 and not is_primitive(thing[0])
