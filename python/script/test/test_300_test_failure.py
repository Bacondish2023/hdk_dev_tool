#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_python_test_case


class Test_300_TestFailure(abstract_python_test_case.AbstractPythonTestCase):

    def setUp(self):
        super().setUp('300_test_failure')


    def test_typical(self):
        # Test
        self._process = subprocess.Popen(
            args=(self._command_test),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_test: Starts')
        stream_verifier_instance.assertPattern('do_test: Test failed')
        process_verifier_instance.assertExit(exit_code = 1, timeout = 60)


if __name__ == '__main__':
    # executed
    unittest.main()
