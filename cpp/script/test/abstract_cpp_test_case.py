#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest

import os
import platform
import shutil


class AbstractCppTestCase(unittest.TestCase):

    def setUp(self, exmaple_project_name):
        self._process = None

        self._path_at_start = os.getcwd()
        self._path_exmaple_project = 'cpp' + os.sep + 'script' + os.sep + 'test' + os.sep + exmaple_project_name
        self._path_code_dir = 'cpp' + os.sep + 'script' + os.sep + 'code'

        self._list_script_filename = (
            'do_build.bat',
            'do_build.sh',
            'do_clean.bat',
            'do_clean.sh',
            'do_lint.bat',
            'do_lint.sh',
            'do_test.bat',
            'do_test.sh',
        )

        self._list_temporary_directory = (
            'zzz_build',
        )

        # Copy scripts
        for filename in self._list_script_filename:
            path_copy_source = self._path_code_dir + os.sep + filename
            path_copy_destination = self._path_exmaple_project + os.sep + filename

            shutil.copy2(path_copy_source, path_copy_destination)

        self._command_build = self._get_command('do_build')
        self._command_clean = self._get_command('do_clean')
        self._command_lint = self._get_command('do_lint')
        self._command_test = self._get_command('do_test')

        # Change directory
        os.chdir(self._path_exmaple_project)


    def tearDown(self):
        if self._process is None:
            pass
        else:
            self._process.kill()

        # Change directory
        os.chdir(self._path_at_start)

        # Remove temporary directory that is created on test
        for temporary_directory in self._list_temporary_directory:
            path_temporary_directory = self._path_exmaple_project + os.sep + temporary_directory
            if os.path.isdir(path_temporary_directory):
                shutil.rmtree(path_temporary_directory)

        # Remove scripts
        for filename in self._list_script_filename:
            path_script = self._path_exmaple_project + os.sep + filename

            if os.path.isfile(path_script):
                os.remove(path_script)


    def _get_command(self, script_name):
        result = None

        if platform.system() == 'Windows':
            result = self._get_script_filename(script_name)
        else: # 'Linux' or 'Darwin'
            result = './' + self._get_script_filename(script_name)

        return result


    def _get_script_filename(self, script_name):
        result = None

        if platform.system() == 'Windows':
            result = script_name + self._get_extension_of_script()
        else: # 'Linux' or 'Darwin'
            result = script_name + self._get_extension_of_script()

        return result


    def _get_extension_of_script(self):
        result = None

        if platform.system() == 'Windows':
            result = '.bat'
        else: # 'Linux' or 'Darwin'
            result = '.sh'

        return result


    def _enable_cmake_toolchain(self):
        script_filename = self._get_script_filename('do_build')
        old_string = None
        new_string = None

        if platform.system() == 'Windows':
            old_string = 'set CMAKE_TOOLCHAIN_FILE='
            new_string = 'set CMAKE_TOOLCHAIN_FILE=toolchain.cmake'
        else: # 'Linux' or 'Darwin'
            old_string = '# CMAKE_TOOLCHAIN_FILE=toolchain.cmake'
            new_string = 'CMAKE_TOOLCHAIN_FILE=toolchain.cmake'

        self._replace_string_in_specified_file(script_filename, old_string, new_string)


    def _enable_pip_requirements(self):
        script_filename = self._get_script_filename('do_build')
        old_string = None
        new_string = None

        if platform.system() == 'Windows':
            old_string = 'set PIP_REQUIREMENTS_FILE='
            new_string = 'set PIP_REQUIREMENTS_FILE=requirements.txt'
        else: # 'Linux' or 'Darwin'
            old_string = '# PIP_REQUIREMENTS_FILE=requirements.txt'
            new_string = 'PIP_REQUIREMENTS_FILE=requirements.txt'

        self._replace_string_in_specified_file(script_filename, old_string, new_string)


    def _replace_string_in_specified_file(self, path_to_file, old, new):
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
