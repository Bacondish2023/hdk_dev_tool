#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_papyrusrt_test_case


class Test_200_LintFailure(abstract_papyrusrt_test_case.AbstractPapyrusRtTestCase):

    def setUp(self):
        super().setUp('200_lint_failure')


    def test_lint_failure(self):
        # Build
        self._process = subprocess.Popen(
            args=(self._command_build),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)

        process_verifier_instance.assertExit(exit_code = 0, timeout = 240)

        # Lint
        self._process = subprocess.Popen(
            args=(self._command_lint),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_lint: Starts')
        stream_verifier_instance.assertPattern('do_lint: Lint failed')
        process_verifier_instance.assertExit(exit_code = 1, timeout = 60)


if __name__ == '__main__':
    # executed
    unittest.main()
