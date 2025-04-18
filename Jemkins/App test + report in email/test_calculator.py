import unittest
import calculator
import math

class TestCalculator(unittest.TestCase):
    def test_add(self):
        self.assertEqual(calculator.add(2, 3), 5)
        self.assertEqual(calculator.add(-1, 1), 0)

    def test_subtract(self):
        self.assertEqual(calculator.subtract(10, 3), 7)
        self.assertEqual(calculator.subtract(0, 5), -5)

    def test_multiply(self):
        self.assertEqual(calculator.multiply(4, 5), 20)
        self.assertEqual(calculator.multiply(-3, 3), -9)

    def test_divide(self):
        self.assertEqual(calculator.divide(10, 2), 5)
        self.assertAlmostEqual(calculator.divide(7, 3), 7/3)

    def test_divide_by_zero(self):
        with self.assertRaises(ValueError):
            calculator.divide(10, 0)

    def test_power(self):
        self.assertEqual(calculator.power(2, 3), 8)
        self.assertEqual(calculator.power(5, 0), 1)
        self.assertAlmostEqual(calculator.power(9, 0.5), 3)

    def test_sqrt(self):
        self.assertAlmostEqual(calculator.sqrt(9), 3)
        self.assertAlmostEqual(calculator.sqrt(2), math.sqrt(2))

    def test_sqrt_negative(self):
        with self.assertRaises(ValueError):
            calculator.sqrt(-4)


