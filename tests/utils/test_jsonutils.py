import data_mod.utils.jsonutils as sut

from tests.helpers.prettifier import print_dict
import unittest

class TestJsonUtils(unittest.TestCase):

    def test_flatten_json_string(self):
        test_string = """{
  "FlowGenerator": {
    "IdentificationProfiles": {
      "Product": {
        "TimeZoneOffset": "+00:00",
        "SerialNumber": "20000000001",
        "UniversalIdentifier": "eca847f8-3950-45c1-aac0-ab7b00b08288"
      }
    }
  }
}""";
        actual = sut.flatten_json_string(test_string)
        print_dict(actual)

        test_string = """{
  "FlowGenerator": {
    "IdentificationProfiles": [
      {
        "Product": {
          "TimeZoneOffset": "+00:00",
          "SerialNumber": "20000000001",
          "UniversalIdentifier": "eca847f8-3950-45c1-aac0-ab7b00b08288"
        }
      },
      {
        "Product": {
          "TimeZoneOffset": "+00:00",
          "SerialNumber": "20000000002",
          "UniversalIdentifier": "eca847f8-3950-45c1-aac0-ab7b00b08299"
        }
      }
    ]
  }
}"""
        actual = sut.flatten_json_string(test_string)
        print_dict(actual)

if __name__ == '__main__':
    unittest.main()