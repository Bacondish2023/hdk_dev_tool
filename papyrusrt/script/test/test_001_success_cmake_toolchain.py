#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest

import os
import subprocess
import platform
import shutil

import integration_test_plugin.stream_verifier as stream_verifier
import integration_test_plugin.process_verifier as process_verifier
import integration_test_plugin.path_verifier as path_verifier


class Test_001_SuccessCmakeToolchain(unittest.TestCase):

    def setUp(self):
        self.__path_at_start = os.getcwd()
        self.__path_exmaple_project = 'papyrusrt' + os.sep + 'script' + os.sep + 'test' + os.sep + '001_success_cmake_toolchain'
        self.__path_code_dir = 'papyrusrt' + os.sep + 'script' + os.sep + 'code'

        self.__list_script_filename = (
            'do_build.bat',
            'do_build.sh',
            'do_clean.bat',
            'do_clean.sh',
            'do_lint.bat',
            'do_lint.sh',
            'do_test.bat',
            'do_test.sh',
            'librts.cmake',
            'start_papyrusrt.bat',
            'start_papyrusrt.sh',
        )

        # Copy scripts
        for filename in self.__list_script_filename:
            path_copy_source = self.__path_code_dir + os.sep + filename
            path_copy_destination = self.__path_exmaple_project + os.sep + filename

            shutil.copy2(path_copy_source, path_copy_destination)

        self.__command_build = _get_command('do_build')
        self.__command_clean = _get_command('do_clean')
        self.__command_lint = _get_command('do_lint')
        self.__command_test = _get_command('do_test')
        self.__command_start_papyrusrt = _get_command('start_papyrusrt')

        self.__process = None

        # Change directory
        os.chdir(self.__path_exmaple_project)


    def tearDown(self):
        if self.__process is None:
            pass
        else:
            self.__process.kill()

        # Change directory
        os.chdir(self.__path_at_start)

        # Remove temporary directory that is created on test
        path_temporary_directory = self.__path_exmaple_project + os.sep + 'zzz_build'
        if os.path.isdir(path_temporary_directory):
            shutil.rmtree(path_temporary_directory)

        path_temporary_directory = self.__path_exmaple_project + os.sep + 'zzz_codegen'
        if os.path.isdir(path_temporary_directory):
            shutil.rmtree(path_temporary_directory)

        path_temporary_directory = self.__path_exmaple_project + os.sep + 'zzz_workspace'
        if os.path.isdir(path_temporary_directory):
            shutil.rmtree(path_temporary_directory)

        # Remove scripts
        for filename in self.__list_script_filename:
            path_script = self.__path_exmaple_project + os.sep + filename

            if os.path.isfile(path_script):
                os.remove(path_script)


    def test_typical(self):
        # Test Settings
        _enable_cmake_toolchain()

        # Assert initial condition
        path_verifier.assertDirectoryNotExist('zzz_build')
        path_verifier.assertDirectoryNotExist('zzz_codegen')

        # Build
        self.__process = subprocess.Popen(
            args=(self.__command_build),
            stdout=subprocess.PIPE,
            #stderr=subprocess.STDOUT,
            universal_newlines=True)
        process_verifier_instance = process_verifier.ProcessVerifier(self.__process)
        stream_verifier_instance = stream_verifier.StreamVerifier(self.__process.stdout)

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


def _get_command(script_name):
    result = None

    if platform.system() == 'Windows':
        result = _get_script_filename(script_name)
    else: # 'Linux' or 'Darwin'
        result = './' + _get_script_filename(script_name)

    return result


def _get_script_filename(script_name):
    result = None

    if platform.system() == 'Windows':
        result = script_name + _get_extension_of_script()
    else: # 'Linux' or 'Darwin'
        result = script_name + _get_extension_of_script()

    return result


def _get_extension_of_script():
    result = None

    if platform.system() == 'Windows':
        result = '.bat'
    else: # 'Linux' or 'Darwin'
        result = '.sh'

    return result


def _enable_cmake_toolchain():
    script_filename = _get_script_filename('do_build')
    old_string = None
    new_string = None

    if platform.system() == 'Windows':
        old_string = 'set CMAKE_TOOLCHAIN_FILE='
        new_string = 'set CMAKE_TOOLCHAIN_FILE=toolchain.cmake'
    else: # 'Linux' or 'Darwin'
        old_string = '# CMAKE_TOOLCHAIN_FILE=toolchain.cmake'
        new_string = 'CMAKE_TOOLCHAIN_FILE=toolchain.cmake'

    _replace_string_in_specified_file(script_filename, old_string, new_string)


def _enable_pip_reqirements():
    script_filename = _get_script_filename('do_build')
    old_string = None
    new_string = None

    if platform.system() == 'Windows':
        old_string = 'set PIP_REQUIREMENTS_FILE='
        new_string = 'set PIP_REQUIREMENTS_FILE=requirements.txt'
    else: # 'Linux' or 'Darwin'
        old_string = '# PIP_REQUIREMENTS_FILE=requirements.txt'
        new_string = 'PIP_REQUIREMENTS_FILE=requirements.txt'

    _replace_string_in_specified_file(script_filename, old_string, new_string)


def _replace_string_in_specified_file(path_to_file, old, new):
    # Sanity check
    if not os.path.isfile(path_to_file):
        raise FileNotFoundError('Specified path "{0}" is not file'.format(path_to_file))

    # Operation
    ## Reads
    content = None
    with open(path_to_file, mode = 'r') as fp:
        content = fp.read()

    ## Replace
    content = content.replace(old, new)

    ## Write back
    with open(path_to_file, mode = 'w') as fp:
        fp.write(content)


if __name__ == '__main__':
    # executed
    unittest.main()
