#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_papyrusrt_test_case


class Test_000_Success(abstract_papyrusrt_test_case.AbstractPapyrusRtTestCase):

    def setUp(self):
        super().setUp('000_success')


    def test_typical(self):
        # Assert initial condition
        path_verifier.assertDirectoryNotExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_codegen')

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
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryExist('zzz_codegen')

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
        path_verifier.assertDirectoryExist('zzz_codegen')

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
        path_verifier.assertDirectoryExist('zzz_codegen')

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
        stream_verifier_instance.assertPattern('do_build: Generates codes')
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryExist('zzz_codegen')

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
        path_verifier.assertDirectoryNotExist('zzz_codegen')


    def test_lint_before_build(self):
        # This should fail
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
        path_verifier.assertDirectoryNotExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_codegen')


    def test_test_before_build(self):
        # This should fail
        self._process = subprocess.Popen(
            args=(self._command_test),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_test: Starts')
        stream_verifier_instance.assertPattern('do_test: Test failed')
        process_verifier_instance.assertExit(exit_code = 1, timeout = 60)
        path_verifier.assertDirectoryNotExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_codegen')


    def test_start(self):
        # Assert initial condition
        path_verifier.assertDirectoryNotExist('zzz_workspace')

        # Start
        self._process = subprocess.Popen(
            args=(self._command_start_papyrusrt, '--dry_run'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('start_papyrusrt: Starts')
        stream_verifier_instance.assertPattern('start_papyrusrt: Creates workspace')
        stream_verifier_instance.assertPattern('start_papyrusrt: Skips to launche Papyrus-RT')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 15)
        path_verifier.assertDirectoryExist('zzz_workspace')

        # Start
        self._process = subprocess.Popen(
            args=(self._command_start_papyrusrt, '--dry_run'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('start_papyrusrt: Starts')
        stream_verifier_instance.assertPattern('start_papyrusrt: Skips to create workspace')
        stream_verifier_instance.assertPattern('start_papyrusrt: Skips to launche Papyrus-RT')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 15)
        path_verifier.assertDirectoryExist('zzz_workspace')


if __name__ == '__main__':
    # executed
    unittest.main()
