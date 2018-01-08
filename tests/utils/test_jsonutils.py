import data_mod.utils.jsonutils as sut

from tests.helpers.prettifier import print_dict

import unittest


class TestJsonUtils(unittest.TestCase):

    test_case_01 = {
        "input": """{
                  "Root": {
                    "Level_1": {
                      "Level_2": {
                        "Level_3a": "+00:00",
                        "Level_3b": "20000000001"
                      }
                    }
                  }
                }""",
        "output": """{".Root.Level_1.Level_2.Level_3a" : "+00:00",
                ".Root.Level_1.Level_2.Level_3b" : "20000000001"}""",
        "comment": "A typical JSON string without array presence"
    }

    test_string_01 = """{
      "Root": {
        "Level_1": {
          "Level_2": {
            "Level_3_a": "+00:00",
            "Level_3b": "20000000001"
          }
        }
      }
    }"""

    test_string_02 = """{
      "Root": {
        "ArrayOfObjects": [
          {
            "Object": {
              "Field_1": "+00:00",
              "Field_2": "20000000001"
            }
          },
          {
            "Object": {
              "Property_A": 1,
              "Property_B": 2,
              "Property_C": "abcd"
            }
          }
        ]
      }
    }"""

    test_string_03 = """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_3": "+00:00",
        "Level_3_array": ["aaa", "bbb"],
        "Level_3_number": 1.5
      }
    }
  }
}"""

    test_string_04 = """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_2": "+00:00",
        "Level_2_array": [
          {
            "Level_3_str": "adfga",
            "Level_3_number": 1.3
          },
          {
            "Level_3_str": "ADFGA",
            "Level_3_number": 1.3237456
          }
        ],
        "Level_2_number": 1.5
      }
    }
  }
}"""

    test_string_05 = """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_2": "+00:00",
        "Level_2_array": [
          {
            "Level_3_str": ["AAA", "BBB", "CCC"],
            "Level_3_number": 1.3
          },
          {
            "Level_3_str": "ADFGA",
            "Level_3_number": [2, 4, 5, 7]
          }
        ],
        "Level_2_number": 1.5
      }
    }
  }
}"""

    test_string_06 = """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_3": "+00:00",
        "Level_3_array": [[1,2,3], [5,7,9]],
        "Level_3_number": 1.5
      }
    }
  }
}"""

    test_string_07 = '{"Root": 1}'

    test_string_08 = '[{"Leaf1": 1}]'

    def test_flatten_tree(self):
        actual = sut.flatten_json_string(TestJsonUtils.test_case_01['input'])
        # print_dict(actual)
        expstr = TestJsonUtils.test_case_01['output'];
        expected = eval(expstr)
        self.assertDictEqual(actual, expected)

if __name__ == '__main__':
    unittest.main()