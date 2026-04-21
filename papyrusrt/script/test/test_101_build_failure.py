#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_papyrusrt_test_case


class Test_101_BuildFailure(abstract_papyrusrt_test_case.AbstractPapyrusRtTestCase):

    def setUp(self):
        super().setUp('101_build_failure')


    def test_build_failure(self):
        # Build
        self._process = subprocess.Popen(
            args=(self._command_build),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_build: Starts')
        stream_verifier_instance.assertPattern('do_build: Checkouts submodules')
        stream_verifier_instance.assertPattern('do_build: Skips to install Python packages')
        stream_verifier_instance.assertPattern('do_build: Generates build system')
        stream_verifier_instance.assertPattern('do_build: Generates codes')
        stream_verifier_instance.assertPattern('do_build: Builds', timeout = 180)
        stream_verifier_instance.assertPattern('do_build: Failed to build')
        process_verifier_instance.assertExit(exit_code = 1, timeout = 60)


if __name__ == '__main__':
    # executed
    unittest.main()
