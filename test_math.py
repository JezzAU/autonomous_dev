import unittest

def add_numbers(a, b):
    """Add two numbers and return the result."""
    return a + b

class TestMath(unittest.TestCase):
    def test_add_numbers(self):
        """Test that add_numbers correctly adds two numbers."""
        self.assertEqual(add_numbers(2, 3), 5)
        self.assertEqual(add_numbers(-1, 1), 0)
        self.assertEqual(add_numbers(0, 0), 0)

if __name__ == "__main__":
    unittest.main()