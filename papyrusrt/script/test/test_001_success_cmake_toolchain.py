#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
import subprocess

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier

import abstract_papyrusrt_test_case


class Test_001_SuccessCmakeToolchain(abstract_papyrusrt_test_case.AbstractPapyrusRtTestCase):

    def setUp(self):
        super().setUp('001_success_cmake_toolchain')


    def test_typical(self):
        # Test Settings
        self._enable_cmake_toolchain()

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
        stream_verifier_instance.assertPattern('do_build: Generates build system using toolchain toolchain.cmake')
        stream_verifier_instance.assertPattern('do_build: Generates codes')
        stream_verifier_instance.assertPattern('do_build: Builds', timeout = 180)
        stream_verifier_instance.assertPattern('do_build: Exits successfully')
        process_verifier_instance.assertExit(exit_code = 0, timeout = 60)
        path_verifier.assertDirectoryExist('zzz_build')
        path_verifier.assertDirectoryExist('zzz_codegen')


if __name__ == '__main__':
    # executed
    unittest.main()
