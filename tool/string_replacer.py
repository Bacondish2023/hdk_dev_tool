#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# standard
import os
import sys
import getopt

# project
# nothing


def main():
    path_file = None
    old_string = None
    new_string = None

    # ---> check argument
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'h', ['help'])
    except getopt.GetoptError as err:
        print(err)
        printUsage()
        sys.exit(1)

    for o, a in opts:
        if (o == '-h') or (o == '--help'):
            printUsage()
            sys.exit(0)

    if len(args) < 3:
        printUsage()
        sys.exit(1)

    path_file = args[0]
    old_string = args[1]
    new_string = args[2]
    # <--- check argument

    # ---> setting
    pass
    # <--- setting

    # ---> operation
    # Sanity check
    if not os.path.isfile(path_file):
        print('Error: Specified path "{0}" is not file'.format(path_file))
        return 1

    if len(old_string) == 0:
        print('Error: Specified old_string "{0}" zero-length'.format(old_string))
        return 1

    # Read
    content = None
    with open(path_file, mode = 'r') as fp:
        content = fp.read()

    # Replace
    content = content.replace(old_string, new_string)

    # Write back
    with open(path_file, mode = 'w') as fp:
        fp.write(content)
    # <--- operation

    return 0


def printUsage():
    application_name = 'string_replacer'

    print('{0}: A tool for replacing string on text file.'.format(application_name))
    print('')
    print('Usage:')
    print('    {0}  print_info <path_file> <old_string> <new_string>'.format(application_name))
    print('    {0} -h'.format(application_name))
    print('')
    print('Print help:')
    print('    -h, --help   show help message')
    print('')


if __name__ == '__main__':
    # executed
    sys.exit( main() )
