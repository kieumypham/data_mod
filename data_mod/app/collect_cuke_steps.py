
from data_mod.utils.prettifier import prettify_list
from data_mod.app.cuke_step import CukeStep

import collections

def read_features():
    features = ['../../scratchpad/acknowledge_requests.feature',
                '../../scratchpad/device_registration.feature',
                '../../scratchpad/device_registration_v2.feature',
                '../../scratchpad/device_registration_v3.feature']

    step_table = {}
    for file in features:
        with open(file) as f:
            for l in f.readlines():
                l = l.strip()
                if l.startswith('Given') or l.startswith('When') or l.startswith('Then') or l.startswith('And'):
                    sentence = CukeStep(l)
                    k = sentence.get_key()
                    if k not in step_table.keys():
                        step_table[k] = []
                    v = sentence.get_value()
                    if v not in step_table[k]:
                        step_table[k].append(v)

    return step_table

def print_step_table(step_table):
    od = collections.OrderedDict(sorted(step_table.items()))
    for k, v in od.items():
        print(k)
        print(prettify_list(v))


if __name__ == '__main__':
    step_table = read_features()
    print_step_table(step_table)