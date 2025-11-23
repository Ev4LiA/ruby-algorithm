class Contest477
  # @param {Integer} n
  # @return {Integer}
  def sum_and_multiply(n)
    n_array = n.to_s.chars
    non_zero_chars = n_array.reject { |c| c == "0" }

    non_zero_chars.reduce(0) { |acc, c| (acc * 10) + c.to_i } * non_zero_chars.sum(&:to_i)
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def max_balanced_subarray(nums)
    # Key: [prefix_xor, even_odd_diff] => earliest index
    seen = {}
    seen[[0, 0]] = -1  # base case: empty prefix has XOR 0 and diff 0

    prefix_xor = 0
    even_odd_diff = 0  # even_count - odd_count
    max_len = 0

    nums.each_with_index do |num, i|
      prefix_xor ^= num
      even_odd_diff += (num.even? ? 1 : -1)

      key = [prefix_xor, even_odd_diff]

      if seen.key?(key)
        # Found a valid subarray from seen[key]+1 to i
        len = i - seen[key]
        max_len = [max_len, len].max
      else
        # Store the earliest index for this (prefix_xor, diff) pair
        seen[key] = i
      end
    end

    max_len
  end

  # @param {String} s
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def sum_and_multiply2(s, queries)
    mod = (10**9) + 7
    queries.map do |li, ri|
      x = 0
      digit_sum = 0

      # Process digits directly from original string, skipping zeros
      (li..ri).each do |i|
        c = s[i]
        if c != '0'
          d = c.to_i
          x = ((x * 10) + d) % mod
          digit_sum += d
        end
      end

      # If no non-zero digits were found, x = 0, so return 0
      # Otherwise return x * sum mod mod
      (x * digit_sum) % mod
    end
  end
end
