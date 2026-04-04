#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import example_project.arithmetic as arithmetic

class Application:
    def __init__(self):
        pass

    def main(self):
        a = 1
        b = 2

        print('{0} + {1} = {2}'.format(a, b, arithmetic.add(a, b)))
