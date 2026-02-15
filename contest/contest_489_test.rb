require 'minitest/autorun'
require_relative 'contest_489'

class Contest489Test < Minitest::Test
  def setup
    @contest = Contest489.new
  end

  def test_first_unique_freq_example_1
    assert_equal 30, @contest.first_unique_freq([20, 10, 30, 30])
  end

  def test_first_unique_freq_example_2
    assert_equal 20, @contest.first_unique_freq([20, 20, 10, 30, 30, 30])
  end

  def test_first_unique_freq_example_3
    assert_equal(-1, @contest.first_unique_freq([10, 10, 20, 20]))
  end

  def test_longest_almost_palindromic_substring_example_1
    assert_equal 4, @contest.longest_almost_palindromic_substring("abca")
  end

  def test_longest_almost_palindromic_substring_example_2
    assert_equal 4, @contest.longest_almost_palindromic_substring("abba")
  end

  def test_longest_almost_palindromic_substring_example_3
    assert_equal 5, @contest.longest_almost_palindromic_substring("zzabba")
  end
end
