require "set"

class Contest484
  # A prefix of s is called a residue if the number of distinct characters
  # in the prefix is equal to len(prefix) % 3.
  # We iterate through each prefix, track distinct characters using a Set,
  # and count how many prefixes satisfy the condition.
  #
  # @param {String} s
  # @return {Integer}
  def residue_prefixes(s)
    count = 0
    distinct_chars = Set.new

    (0...s.length).each do |i|
      distinct_chars.add(s[i])
      prefix_length = i + 1
      count += 1 if distinct_chars.size == (prefix_length % 3)
    end

    count
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def centered_subarrays(nums)
    n = nums.length
    return 0 if n.zero?

    # Precompute prefix sums: prefix[i] = sum(nums[0..i-1])
    prefix = Array.new(n + 1, 0)
    (0...n).each do |i|
      prefix[i + 1] = prefix[i] + nums[i]
    end

    count = 0

    # For each subarray nums[i..j]
    (0...n).each do |i|
      # Track elements in current subarray using a Set
      elements = Set.new

      (i...n).each do |j|
        elements.add(nums[j])
        subarray_sum = prefix[j + 1] - prefix[i]
        count += 1 if elements.include?(subarray_sum)
      end
    end

    count
  end

  # @param {String[]} words
  # @return {Integer}
  def count_pairs(words)
    # Normalize a string by shifting it so the first character becomes 'a'
    normalize = lambda do |word|
      return "" if word.empty?

      shift = ("a".ord - word[0].ord) % 26
      word.chars.map { |c| (((c.ord - "a".ord + shift) % 26) + "a".ord).chr }.join
    end

    # Group words by their normalized form
    groups = Hash.new(0)
    words.each do |word|
      normalized = normalize.call(word)
      groups[normalized] += 1
    end

    # Count pairs: for each group with k strings, there are k*(k-1)/2 pairs
    groups.values.sum { |count| count * (count - 1) / 2 }
  end
end
