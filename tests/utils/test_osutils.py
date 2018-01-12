from data_mod.utils import osutils as sut
# from data_mod.utils.prettifier import prettify_list
from tests import TEST_HOME

import unittest
import os


class TestOsUtils(unittest.TestCase):
    def test_list_files(self):
        test_folder = os.sep.join([TEST_HOME, 'resources'])
        dir_names, file_names = sut.list_files_and_folders(test_folder, '.+\\.feature$')
        self.assertEqual(len(dir_names), 1)
        self.assertEqual(len(file_names), 56)
        # print(prettify_list(dir_names))
        # print(prettify_list(file_names))

if __name__ == '__main__':
    unittest.main()
