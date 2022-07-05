def fizz_buzz(value):
    # if value is multiple of 3
    if is_multiple(value, 3):
        # if value is multiple of 5 (and 3)
        if is_multiple(value, 5):
            return "FizzBuzz"

        return "Fizz"
    # if value is multiple of 5
    if is_multiple(value, 5):
        return "Buzz"

    return str(value)

def is_multiple(value, mod):
    return (value % mod) == 0

def check_fizz_buzz(value, expected_value):
    ret_val = fizz_buzz(value)
    assert ret_val == expected_value

def test_return_1_with_1_passed_in():
    check_fizz_buzz(1, "1")

def test_return_2_with_2_passed_in():
    check_fizz_buzz(2, "2")

def test_return_Fizz_with_3_passed_in():
    check_fizz_buzz(3, "Fizz")

def test_return_Buzz_with_5_passed_in():
    check_fizz_buzz(5, "Buzz")

def test_return_Fizz_with_6_passed_in():
    check_fizz_buzz(6, "Fizz")

def test_return_Buzz_with_10_passed_in():
    check_fizz_buzz(10, "Buzz")

def test_return_FizzBuzz_with_15_passed_in():
    check_fizz_buzz(15, "FizzBuzz")
