#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# standard
import unittest

# project
import example_project.arithmetic as arithmetic


class TestArithmetic(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_typical(self):
        self.assertEqual( 3, arithmetic.add(1, 2) )


if __name__ == '__main__':
    # executed
    unittest.main()
