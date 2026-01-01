#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import traceback

import example_project.application as application


def main():
    result = None

    try:
        app = application.Application()
        result = app.main()
    except:
        traceback.print_exc()
        sys.exit(1)

    return result


if __name__ == '__main__':
    # executed
    sys.exit( main() )
