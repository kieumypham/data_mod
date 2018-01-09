from data_mod.utils import prettifier as sut

import unittest


class TestPrettifier(unittest.TestCase):
    def test_prettify_dict(self):
        data = {"FieldA": 1234, "FieldB": "Some string"}
        actual = sut.prettify_dict(data)
        expected = """{
"FieldA": 1234,
"FieldB": "Some string"
}"""
        self.assertEqual(actual, expected)

if __name__ == '__main__':
    unittest.main()