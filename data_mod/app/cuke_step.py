import re


class CukeStep(object):
    def __init__(self, init_str):
        self.value = init_str
        self.chop_given_when_then()\
            .mask_string_parameter()\
            .mask_numerical_parameter()

    def replace_all(self, regex, substitution):
        self.value = re.sub(regex, substitution, self.value)

    def chop_given_when_then(self):
        for word in ['Given', 'When', 'Then', 'And']:
            if self.value.startswith(word):
                self.value = self.value[len(word):]
        return self

    def mask_string_parameter(self):
        quoted_string = '\"[a-zA-Z 0-9]+\"'
        self.value = re.sub(quoted_string, '<???>', self.value)
        return self

    def mask_numerical_parameter(self):
        num_parm = '\d+'
        self.value = re.sub(num_parm, '<???>', self.value)
        return self

    def get_key(self):
        """TODO: remove non essential words: a / the / and / should"""
        return ' '.join(sorted(self.value.split()))

    def get_value(self):
        return self.value