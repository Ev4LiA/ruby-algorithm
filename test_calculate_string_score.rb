require 'minitest/autorun'
require_relative 'calculate_string_score'

class TestCalculateStringScore < Minitest::Test
  def test_example_1
    s = "cooear"
    assert_equal 2, calculate_string_score(s)
  end

  def test_example_2
    s = "axeyizou"
    assert_equal 1, calculate_string_score(s)
  end

  def test_example_3
    s = "au 123"
    assert_equal 0, calculate_string_score(s)
  end

  def test_no_vowels_no_consonants
    s = "123 !@#"
    assert_equal 0, calculate_string_score(s)
  end

  def test_only_vowels
    s = "aeiou"
    assert_equal 0, calculate_string_score(s)
  end

  def test_only_consonants
    s = "bcdfgh"
    assert_equal 0, calculate_string_score(s)
  end

  def test_empty_string
    s = ""
    assert_equal 0, calculate_string_score(s)
  end

  def test_mixed_case_should_ignore_upper
    s = "AeiOuBCd"
    # Should only count 'e', 'i', 'o', 'u' for vowels, 'c', 'd' for consonants
    # v = 4, c = 2. floor(4/2) = 2
    # Oh wait, the problem says "s consisting of lowercase English letters".
    # So, uppercase letters are not vowels or consonants.
    # v=0, c=0 => score=0
    assert_equal 0, calculate_string_score(s)
  end
end
