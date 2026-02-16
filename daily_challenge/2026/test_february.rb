require 'minitest/autorun'
require_relative 'february'

class TestReverseBits < Minitest::Test
  def setup
    @solver = Solution.new
  end

  def test_example_1
    n = 43261596
    expected_output = 964176192
    assert_equal expected_output, @solver.reverse_bits(n)
  end

  def test_example_2
    n = 2147483644
    expected_output = 1073741822
    assert_equal expected_output, @solver.reverse_bits(n)
  end

  def test_zero
    n = 0
    expected_output = 0
    assert_equal expected_output, @solver.reverse_bits(n)
  end

  def test_one
    n = 1
    # Binary: 000...001
    # Reversed: 100...000 (2^31)
    expected_output = 2147483648 # 2**31
    assert_equal expected_output, @solver.reverse_bits(n)
  end

  def test_max_even_32bit_minus_2
    # The constraint is 0 <= n <= 2^31 - 2, and n is even.
    # So the largest 'n' would be 2^31 - 2 = 2147483646
    n = 2147483646 # Binary: 01111111111111111111111111111110
    # Reversed: 01111111111111111111111111111110 (same as original, except the last two bits are swapped)
    # The reversed bits would be 01111111111111111111111111111110
    # The reversed value is also 2147483646
    # No, wait. 0111...110 reversed is 0111...110. The bit at position 1 (0-indexed from right) is 1.
    # The bit at position 30 is 0.
    # The original binary is 01111111111111111111111111111110 (2^31 - 2)
    # The reversed binary:
    # 0 (bit 31) -> 0 (bit 0)
    # 1 (bit 30) -> 0 (bit 1)
    # ...
    # 1 (bit 1)  -> 1 (bit 30)
    # 0 (bit 0)  -> 0 (bit 31)
    # This results in the same number.
    # Let's double check.
    # 2^31 - 2 = 2147483646
    # 01111111111111111111111111111110
    # Reversing this would be
    # 01111111111111111111111111111110
    # Yes, it is the same.

    # Let's use a simpler number for clarity if the above is confusing.
    # n = 4 (000...100)
    # expected_output for 4 (00...0100) -> 0100...000 (2^30)
    # n = 2 (000...010)
    # expected_output for 2 (00...0010) -> 0100...000 (2^31)
    # No, the number of bits is 32.
    # for n=2 (0...010), reversed: 010...0
    # It would be 2^30.
    # Let's test with a small number.
    n_small = 2 # 0...010 (binary)
    # Expected: 010...0 (binary) which is 2^30 = 1073741824
    assert_equal 1073741824, @solver.reverse_bits(n_small)

    n_small_2 = 4 # 0...100 (binary)
    # Expected: 001...0 (binary) which is 2^29 = 536870912
    assert_equal 536870912, @solver.reverse_bits(n_small_2)
  end
end
