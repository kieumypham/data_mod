import data_mod.utils.jsonutils as sut

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
        "output": """{"Root.Level_1.Level_2.Level_3a" : "+00:00",
                "Root.Level_1.Level_2.Level_3b" : "20000000001"}""",
        "comment": "A typical JSON string without array presence"
    }

    test_case_02 = {
        "input": """{
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
            }""",
        "output": """{
                "Root.ArrayOfObjects[0].Object.Field_1": "+00:00",
                "Root.ArrayOfObjects[0].Object.Field_2": "20000000001",
                "Root.ArrayOfObjects[1].Object.Property_A": 1,
                "Root.ArrayOfObjects[1].Object.Property_B": 2,
                "Root.ArrayOfObjects[1].Object.Property_C": "abcd"
                }""",
        "comment": "A JSON which has (non-nested) array of objects"
    }

    test_case_03 = {
        "input": """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_3": "+00:00",
        "Level_3_array": ["aaa", "bbb"],
        "Level_3_number": 1.5
      }
    }
  }
}""",
        "output": """{
"Root.Level_1.Level_2.Level_3": "+00:00",
"Root.Level_1.Level_2.Level_3_array": ['aaa', 'bbb'],
"Root.Level_1.Level_2.Level_3_number": 1.5
}""",
        "comment": "JSON has array of primitive items"
    }

    test_case_04 = {
        "input": """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_3": "+00:00",
        "Level_3_array": [
          {
            "Level_4_str": "adfga",
            "Level_4_number": 1.3
          },
          {
            "Level_4_str": "ADFGA",
            "Level_4_number": 1.3237456
          }
        ],
        "Level_3_number": 1.5
      }
    }
  }
}""",
        "output": """{
"Root.Level_1.Level_2.Level_3": "+00:00",
"Root.Level_1.Level_2.Level_3_array[0].Level_4_str": "adfga",
"Root.Level_1.Level_2.Level_3_array[0].Level_4_number": 1.3,
"Root.Level_1.Level_2.Level_3_array[1].Level_4_str": "ADFGA",
"Root.Level_1.Level_2.Level_3_array[1].Level_4_number": 1.3237456,
"Root.Level_1.Level_2.Level_3_number": 1.5
}""",
        "comment": "JSON has array sits inside a deeper level, and data inside the array contains float"
    }

    test_case_05 = {
        "input": """{
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
}""",
        "output": """{
"Root.Level_1.Level_2.Level_2": "+00:00",
"Root.Level_1.Level_2.Level_2_array[0].Level_3_str": ['AAA', 'BBB', 'CCC'],
"Root.Level_1.Level_2.Level_2_array[0].Level_3_number": 1.3,
"Root.Level_1.Level_2.Level_2_array[1].Level_3_str": "ADFGA",
"Root.Level_1.Level_2.Level_2_array[1].Level_3_number": [2, 4, 5, 7],
"Root.Level_1.Level_2.Level_2_number": 1.5
}""",
        "comment": "JSON has nested arrays"
    }

    test_case_06 = {
        "input": """{
  "Root": {
    "Level_1": {
      "Level_2": {
        "Level_3": "+00:00",
        "Level_3_array": [[1,2,3], [5,7,9]],
        "Level_3_number": 1.5
      }
    }
  }
}""",
        "output": """{
"Root.Level_1.Level_2.Level_3": "+00:00",
"Root.Level_1.Level_2.Level_3_array[0]": [1, 2, 3],
"Root.Level_1.Level_2.Level_3_array[1]": [5, 7, 9],
"Root.Level_1.Level_2.Level_3_number": 1.5
}""",
        "comment": "JSON has nested arrays of primitives"
    }

    test_case_07 = {
        "input": '{"Root": 1}',
        "output": """{
"Root": 1
}""",
        "comment": "Simple JSON that has only one level of dictionary"
    }

    test_case_08 = {
        "input": '[{"Leaf1": 1}]',
        "output": """{
"": [{'Leaf1': 1}]
}
""",
        "comment": "A JSON which starts with array instead of dictionary."
    }

    def test_flatten_tree(self):
        for tcase in [TestJsonUtils.test_case_01,
                      TestJsonUtils.test_case_02,
                      TestJsonUtils.test_case_03,
                      TestJsonUtils.test_case_04,
                      TestJsonUtils.test_case_05,
                      TestJsonUtils.test_case_06,
                      TestJsonUtils.test_case_07,
                      TestJsonUtils.test_case_08]:
            self.excute_test_case(tcase)

    def excute_test_case(self, testcase):
        actual = sut.flatten_json_string(testcase['input'])
        expected = eval(testcase['output'])
        self.assertDictEqual(actual, expected)

if __name__ == '__main__':
    unittest.main()