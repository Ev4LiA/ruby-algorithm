class Contest170
  # @param {Integer} n
  # @return {Integer}
  def minimum_flips(n)
    s = n.to_s(2)

    len = s.length
    flips = 0

    (0...len).each do |i|
      flips += 1 if s[i] != s[len - 1 - i]
    end

    flips
  end

  # @param {Integer} num1
  # @param {Integer} num2
  # @return {Integer}
  def total_waviness(num1, num2)
    total = 0

    (num1..num2).each do |num|
      digits = num.to_s.chars.map(&:to_i)
      next if digits.length < 3

      (1...digits.length - 1).each do |i|
        if digits[i] > digits[i - 1] && digits[i] > digits[i + 1]
          total += 1 # peak
        elsif digits[i] < digits[i - 1] && digits[i] < digits[i + 1]
          total += 1 # valley
        end
      end
    end

    total
  end

  # @param {Integer} n
  # @param {Integer} target
  # @return {Integer[]}
  def lex_smallest_negated_perm(n, target)
    min_sum = -n * (n + 1) / 2
    max_sum = n * (n + 1) / 2

    # Check if target is achievable
    return [] if target < min_sum || target > max_sum
    return [] if (target - min_sum).odd?

    # Start with all positive: [1, 2, ..., n]
    result = (1..n).to_a
    current_sum = max_sum
    diff = current_sum - target

    # Flip numbers from largest to smallest (right to left) to reduce sum
    # Each flip reduces sum by 2k (from +k to -k)
    # This strategy minimizes lexicographic order by keeping early elements positive
    # when possible, and only flipping when necessary
    n.downto(1) do |i|
      break if diff.zero?

      flip_reduction = 2 * i
      if diff >= flip_reduction
        result[i - 1] = -i
        diff -= flip_reduction
      end
    end

    result.sort!
  end

  # @param {Integer} num1
  # @param {Integer} num2
  # @return {Integer}
  def total_waviness2(num1, num2); end
end
