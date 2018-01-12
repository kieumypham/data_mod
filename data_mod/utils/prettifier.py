def prettify_dict(data):
    if isinstance(data, dict):
        serialized_content = ''
        for k, v in data.items():
            t_key = k if isinstance(k, str) else repr(k)
            t_value = '"%s"' %(v) if isinstance(v, str) else v
            serialized_content += '\n\t"%s": %s,' %(t_key, t_value)
        return '{%s\n}' %(serialized_content[:-1])
    else:
        raise Exception("Data is not a dictionary")

def prettify_list(data):
    if isinstance(data, list):
        serialized_content = ''
        for item in data:
            serialized_content += '\n\t%s,' %(item)
        return '[%s\n]' %(serialized_content[:-1])
    else:
        raise Exception("Data is not a list")