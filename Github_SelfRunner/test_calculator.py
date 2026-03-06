# test_calculator.py - Unit tests for the calculator
# These tests are run automatically by the GitHub Actions self-hosted runner

import pytest
from calculator import add, subtract, multiply, divide

class TestAdd:
    def test_add_positive_numbers(self):
        assert add(10, 5) == 15

    def test_add_negative_numbers(self):
        assert add(-3, -7) == -10

    def test_add_zero(self):
        assert add(0, 5) == 5

class TestSubtract:
    def test_subtract_positive_numbers(self):
        assert subtract(10, 5) == 5

    def test_subtract_negative_result(self):
        assert subtract(3, 7) == -4

class TestMultiply:
    def test_multiply_positive_numbers(self):
        assert multiply(4, 3) == 12

    def test_multiply_by_zero(self):
        assert multiply(5, 0) == 0

class TestDivide:
    def test_divide_positive_numbers(self):
        assert divide(10, 2) == 5.0

    def test_divide_by_zero_raises_error(self):
        with pytest.raises(ValueError, match="Cannot divide by zero"):
            divide(10, 0)
