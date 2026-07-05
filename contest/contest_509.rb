class Contest509
  # Sum of Integers with Maximum Digit Range
  # @param {Integer[]} nums
  # @return {Integer}
  def max_digit_range(nums)
    # Helper: compute digit range of a single integer
    digit_range = lambda do |x|
      digits = x.to_s.chars.map! { |ch| ch.ord - 48 } # faster than ch.to_i
      digits.max - digits.min
    end

    # First pass: find maximum digit range
    max_range = 0
    ranges = Array.new(nums.length)

    nums.each_with_index do |num, i|
      r = digit_range.call(num)
      ranges[i] = r
      max_range = r if r > max_range
    end

    # Second pass: sum numbers whose digit range equals max_range
    sum = 0
    nums.each_with_index do |num, i|
      sum += num if ranges[i] == max_range
    end

    sum
  end

  # Subsequence After One Replacement
  # @param {String} s
  # @param {String} t
  # @return {Boolean}
  def can_make_subsequence(s, t); end
end
