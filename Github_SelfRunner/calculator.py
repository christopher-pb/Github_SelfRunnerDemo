# calculator.py - Simple Python Calculator
# This is used to demonstrate GitHub Actions with a self-hosted runner

def add(a, b):
    """Add two numbers."""
    return a + b

def subtract(a, b):
    """Subtract b from a."""
    return a - b

def multiply(a, b):
    """Multiply two numbers."""
    return a * b

def divide(a, b):
    """Divide a by b. Raises ValueError if b is zero."""
    if b == 0:
        raise ValueError("Cannot divide by zero!")
    return a / b

if __name__ == "__main__":
    print("=== Simple Calculator ===")
    print(f"10 + 5  = {add(10, 5)}")
    print(f"10 - 5  = {subtract(10, 5)}")
    print(f"10 * 5  = {multiply(10, 5)}")
    print(f"10 / 5  = {divide(10, 5)}")
    print("Calculator ran successfully on self-hosted runner!")
