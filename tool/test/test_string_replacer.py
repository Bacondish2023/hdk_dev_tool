#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import os
import subprocess
import tempfile

import integration_test_plugin.process_verifier as process_verifier


class Test_300_TestFailure(unittest.TestCase):

    def setUp(self):
        self.__command = ('python', '-B', 'tool' + os.sep + 'string_replacer.py')
        self.__content = '''
Hello, I am test data.
Version: 1.0.0
'''[1:]


    def tearDown(self):
        pass


    def test_typical(self):
        expected = '''
Hello, I am test data.
Version: 1.1.0
'''[1:]


        with tempfile.TemporaryDirectory() as tmpdir:
            path = tmpdir + os.sep + 'test_data.txt'

            # Create test file
            with open(path, mode = 'w') as fp:
                fp.write(self.__content)

            # Replace
            self.__process = subprocess.Popen(
                args=self.__command + (path, 'Version: 1.0.0', 'Version: 1.1.0'),
                stdout=subprocess.PIPE,
                #stderr=subprocess.STDOUT,
                universal_newlines=True)
            process_verifier_instance = process_verifier.ProcessVerifier(self.__process)

            process_verifier_instance.assertExit(exit_code = 0, timeout = 10)

            # Read
            actual = None
            with open(path, mode = 'r') as fp:
                actual = fp.read()

            # Verify
            self.assertEqual( expected, actual )


    def test_failure_wrong_path(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = tmpdir + os.sep + 'test_data.txt'

            # This test does not create test file to cause error

            # Replace
            self.__process = subprocess.Popen(
                args=self.__command + (path, 'Version: 1.0.0', 'Version: 1.1.0'),
                stdout=subprocess.PIPE,
                #stderr=subprocess.STDOUT,
                universal_newlines=True)
            process_verifier_instance = process_verifier.ProcessVerifier(self.__process)

            process_verifier_instance.assertExit(exit_code = 1, timeout = 10)


    def test_failure_wrong_string(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = tmpdir + os.sep + 'test_data.txt'

            # Create test file
            with open(path, mode = 'w') as fp:
                fp.write(self.__content)

            # Replace
            self.__process = subprocess.Popen(
                args=self.__command + (path, '', 'Version: 1.1.0'),
                stdout=subprocess.PIPE,
                #stderr=subprocess.STDOUT,
                universal_newlines=True)
            process_verifier_instance = process_verifier.ProcessVerifier(self.__process)

            process_verifier_instance.assertExit(exit_code = 1, timeout = 10)


if __name__ == '__main__':
    # executed
    unittest.main()
