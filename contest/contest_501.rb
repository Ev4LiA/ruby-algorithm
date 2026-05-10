class Contest501
  # @param {Integer[]} nums
  # @return {Integer[]}
  def concat_with_reverse(nums)
    nums + nums.reverse
  end

  # @param {String[]} chunks
  # @param {String[]} queries
  # @return {Integer[]}
  def count_word_occurrences(chunks, queries)
    s = chunks.join
    n = s.length

    freq = Hash.new(0)

    i = 0
    while i < n
      # skip separators (not letter and not "valid hyphen")
      i += 1 while i < n && !valid_word_char?(s, i)
      break if i >= n

      start = i
      # consume a maximal run of valid word characters
      i += 1 while i < n && valid_word_char?(s, i)
      word = s[start...i]

      freq[word] += 1
    end

    queries.map { |q| freq[q] }
  end

  def letter?(ch)
    "a" <= ch && ch <= "z"
  end

  # "Valid word character" in the *string s*:
  #  - any lowercase letter
  #  - a hyphen that is surrounded by lowercase letters
  def valid_word_char?(s, i)
    ch = s[i]
    return true if letter?(ch)

    return false unless ch == "-"

    # hyphen is valid only if surrounded by letters in s
    left_letter  = i - 1 >= 0        && letter?(s[i - 1])
    right_letter = i + 1 < s.length  && letter?(s[i + 1])
    left_letter && right_letter
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def min_array_sum(nums)
    max_val = nums.max

    # mark which values exist
    present = Array.new(max_val + 1, false)
    nums.each { |x| present[x] = true }

    # min_reachable[v] = minimum value we can reduce v to
    min_reachable = Array.new(max_val + 1, Float::INFINITY)
    1.upto(max_val) do |v|
      min_reachable[v] = v if present[v]
    end

    # for every value d that exists, all its multiples that exist
    # can be directly reduced to d (since multiple % d == 0)
    1.upto(max_val) do |d|
      next unless present[d]

      multiple = 2 * d
      while multiple <= max_val
        min_reachable[multiple] = [min_reachable[multiple], d].min if present[multiple]
        multiple += d
      end
    end

    # sum minimal reachable value for each element
    nums.sum { |x| min_reachable[x].to_i }
  end
end
