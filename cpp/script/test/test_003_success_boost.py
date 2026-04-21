#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_cpp_test_case


@unittest.skip('Skip to avoid link error on CI workflow')
class Test_003_SuccessBoost(abstract_cpp_test_case.AbstractCppTestCase):

    def setUp(self):
        super().setUp('003_success_boost')


    def test_typical(self):
        # Assert initial condition
        path_verifier.assertDirectoryNotExist('zzz_build')

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
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')

        # Lint
        self._process = subprocess.Popen(
            args=(self._command_lint),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_lint: Starts')
        stream_verifier_instance.assertPattern('do_lint: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')

        # Test
        self._process = subprocess.Popen(
            args=(self._command_test),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_test: Starts')
        stream_verifier_instance.assertPattern('do_test: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')

        # 2nd build should succeed
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
        stream_verifier_instance.assertPattern('do_build: Skips to generate build system')
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')

        # Clean
        self._process = subprocess.Popen(
            args=(self._command_clean),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_clean: Starts')
        stream_verifier_instance.assertPattern('do_clean: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryNotExist('zzz_build')


if __name__ == '__main__':
    # executed
    unittest.main()
