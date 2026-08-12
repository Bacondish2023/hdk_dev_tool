#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess
import os
import shutil

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_avr8_test_case


class Test_000_Success(abstract_avr8_test_case.AbstractAvr8TestCase):

    def setUp(self):
        super().setUp('000_success')


    @unittest.skipUnless(abstract_avr8_test_case.isToolchainAvailable(), 'Toolchain seems to be unavailable')
    def test_typical_all(self):
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
        stream_verifier_instance.assertPattern('do_build: Processes "real" preset')
        stream_verifier_instance.assertPattern('do_build: Generates build system')
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Processes "simulation" preset')
        stream_verifier_instance.assertPattern('do_build: Generates build system')
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.elf')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.eep')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.lss')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.size')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'example-0.0.0.zip')

        # Lint
        self._process = subprocess.Popen(
            args=(self._command_lint),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_lint: Starts')
        stream_verifier_instance.assertPattern('do_lint: Processes "real" preset')
        stream_verifier_instance.assertPattern('do_lint: Processes "simulation" preset')
        stream_verifier_instance.assertPattern('do_lint: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.elf')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.eep')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.lss')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.size')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'example-0.0.0.zip')

        # Test
        self._process = subprocess.Popen(
            args=(self._command_test),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_test: Starts')
        stream_verifier_instance.assertPattern('do_test: Processes "real" preset')
        stream_verifier_instance.assertPattern('do_test: Processes "simulation" preset')
        stream_verifier_instance.assertPattern('do_test: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.elf')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.eep')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.lss')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.size')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'example-0.0.0.zip')

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
        stream_verifier_instance.assertPattern('do_build: Processes "real" preset')
        stream_verifier_instance.assertPattern('do_build: Skips to generate build system')
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Processes "simulation" preset')
        stream_verifier_instance.assertPattern('do_build: Skips to generate build system')
        stream_verifier_instance.assertPattern('do_build: Builds')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.elf')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.eep')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.lss')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'application.size')
        path_verifier.assertFileExist('zzz_build' + os.sep + 'real' + os.sep + 'example-0.0.0.zip')

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


    @unittest.skipUnless(abstract_avr8_test_case.isToolchainAvailable(), 'Toolchain seems to be unavailable')
    def test_typical_real(self):
        # Assert initial condition
        path_verifier.assertDirectoryNotExist('zzz_build')

        # Build
        self._process = subprocess.Popen(
            args=(self._command_build, 'real'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_build: Starts')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryExist('zzz_build' + os.sep + 'real')
        path_verifier.assertDirectoryNotExist('zzz_build' + os.sep + 'simulation')

        # Lint
        self._process = subprocess.Popen(
            args=(self._command_lint, 'real'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_lint: Starts')
        stream_verifier_instance.assertPattern('do_lint: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryExist('zzz_build' + os.sep + 'real')
        path_verifier.assertDirectoryNotExist('zzz_build' + os.sep + 'simulation')

        # Test
        self._process = subprocess.Popen(
            args=(self._command_test, 'real'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_test: Starts')
        stream_verifier_instance.assertPattern('do_test: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryExist('zzz_build' + os.sep + 'real')
        path_verifier.assertDirectoryNotExist('zzz_build' + os.sep + 'simulation')

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


    def test_typical_simulation(self):
        # Assert initial condition
        path_verifier.assertDirectoryNotExist('zzz_build')

        # Build
        self._process = subprocess.Popen(
            args=(self._command_build, 'simulation'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_build: Starts')
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_build' + os.sep + 'real')
        path_verifier.assertDirectoryExist('zzz_build' + os.sep + 'simulation')

        # Lint
        self._process = subprocess.Popen(
            args=(self._command_lint, 'simulation'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_lint: Starts')
        stream_verifier_instance.assertPattern('do_lint: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_build' + os.sep + 'real')
        path_verifier.assertDirectoryExist('zzz_build' + os.sep + 'simulation')

        # Test
        self._process = subprocess.Popen(
            args=(self._command_test, 'simulation'),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self._process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self._process.stdout)

        stream_verifier_instance.assertPattern('do_test: Starts')
        stream_verifier_instance.assertPattern('do_test: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_build' + os.sep + 'real')
        path_verifier.assertDirectoryExist('zzz_build' + os.sep + 'simulation')

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


    @unittest.skipUnless(abstract_avr8_test_case.isToolchainAvailable(), 'Toolchain seems to be unavailable')
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


    @unittest.skipUnless(abstract_avr8_test_case.isToolchainAvailable(), 'Toolchain seems to be unavailable')
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


if __name__ == '__main__':
    # executed
    unittest.main()
