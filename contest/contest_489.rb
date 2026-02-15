class Contest489
  # @param {Integer[]} bulbs
  # @return {Integer[]}
  def toggle_light_bulbs(bulbs)
    hash = Hash.new(0)
    bulbs.each { |bulb| hash[bulb] += 1 }

    res = []

    hash.each do |bulb, count|
      res << bulb if count.odd?
    end

    res.sort
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def first_unique_freq(nums)
    freq_counts = Hash.new(0)
    nums.each { |num| freq_counts[num] += 1 }

    freq_freq_counts = Hash.new(0)
    freq_counts.each { |_, freq| freq_freq_counts[freq] += 1 }

    nums.each do |num|
      freq = freq_counts[num]
      return num if freq_freq_counts[freq] == 1
    end

    -1
  end

  # @param {String} s
  # @return {Integer}
  def longest_almost_palindromic_substring(s)
    n = s.length
    return 0 if n < 2

    # is_palindrome[i][j] is true if s[i..j] is a palindrome
    is_palindrome = Array.new(n) { Array.new(n, false) }
    # can_be_almost_palindrome[i][j] is true if s[i..j] can become a palindrome
    # by removing exactly one character (and is not already a palindrome itself)
    can_be_almost_palindrome = Array.new(n) { Array.new(n, false) }

    max_len = 0

    # Fill is_palindrome table
    (0...n).each do |i|
      is_palindrome[i][i] = true # All single characters are palindromes
    end

    (0...n - 1).each do |i|
      is_palindrome[i][i + 1] = true if s[i] == s[i + 1]
    end

    (2...n).each do |len_val| # len_val is the length of the substring, starting from 3
      (0..n - len_val).each do |i|
        j = i + len_val - 1
        is_palindrome[i][j] = true if s[i] == s[j] && is_palindrome[i + 1][j - 1]
      end
    end

    # Now, iterate through all possible lengths and starting positions
    # to fill can_be_almost_palindrome and find the max_len.
    # We must iterate by length to ensure inner DP states are computed first.
    (1..n).each do |len|
      (0..n - len).each do |i|
        j = i + len - 1

        # Case 1: Substring is already a palindrome of length >= 2
        # Such substrings are almost-palindromic because removing any character
        # (if len > 1) can result in a palindrome or an empty string.
        # "non-empty string that reads the same forward and backward".
        # We need to remove EXACTLY one character and get a non-empty palindrome.
        # For len 2 "aa" -> remove 'a' -> "a" (palindrome, non-empty)
        # For len 3 "aba" -> remove 'b' -> "aa" (palindrome, non-empty)
        if is_palindrome[i][j] && len >= 2
          max_len = [max_len, len].max
          next # No need to check can_be_almost_palindrome for this.
        end

        # Case 2: Substring is not a palindrome, but can become one by removing one character.
        next unless len >= 2 # Minimum length for an almost-palindromic string that is not a palindrome is 2

        if s[i] == s[j]
          # If outer characters match, then s[i..j] is almost-palindromic
          # if the inner substring s[i+1..j-1] is also almost-palindromic.
          # This applies for len > 2. For len = 2, it would have been caught by is_palindrome check.
          can_be_almost_palindrome[i][j] = can_be_almost_palindrome[i + 1][j - 1] if len > 2
        else # s[i] != s[j]
          # If outer characters don't match, we *must* remove either s[i] or s[j].
          # The remaining substring must then be a palindrome.
          can_be_almost_palindrome[i][j] = is_palindrome[i + 1][j] || is_palindrome[i][j - 1]
        end

        max_len = [max_len, len].max if can_be_almost_palindrome[i][j]
      end
    end

    max_len
  end
end
