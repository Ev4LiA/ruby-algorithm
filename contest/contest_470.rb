class Contest470
  # @param {Integer[]} nums
  # @return {Integer}
  def alternating_sum(nums)
    nums.each_with_index do |num, index|
      nums[index] = num * (index.even? ? 1 : -1)
    end

    nums.sum
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def longest_subsequence(nums)
    n = nums.length
    total = 0
    nums.each { |x| total ^= x }

    return n if total != 0
    return n - 1 if nums.any?(&:nonzero?)

    0
  end

  # Remove all non-overlapping k-balanced substrings from s until none remain.
  # A k-balanced substring is '(' * k + ')' * k
  # @param [String] s
  # @param [Integer] k
  # @return [String]
  def remove_substring(s, k)
    # Each element: [char, run_length]
    runs = []

    s.each_char do |ch|
      if runs.any? && runs[-1][0] == ch
        runs[-1][1] += 1
      else
        runs << [ch, 1]
      end

      # attempt cancellation as long as the last two runs form '('{>=k} followed by ')'{>=k}
      loop do
        break unless runs.size >= 2

        open_run  = runs[-2]
        close_run = runs[-1]

        break unless open_run[0] == "(" && close_run[0] == ")" && open_run[1] >= k && close_run[1] >= k

        open_run[1]  -= k
        close_run[1] -= k

        runs.pop if close_run[1].zero?
        runs.pop if open_run[1].zero?

        # merge same-char runs that may now be adjacent
        if runs.size >= 2 && runs[-1][0] == runs[-2][0]
          runs[-2][1] += runs[-1][1]
          runs.pop
        end
      end
    end

    runs.map { |ch, cnt| ch * cnt }.join
  end

  # @param {Integer} n
  # @return {Integer}
  def count_no_zero_pairs(n)
    digits = n.to_s.reverse.chars.map(&:to_i) # LSB first
    m = digits.size

    # Track: has_seen_nonzero and has_seen_zero
    @memo = {}

    solve = lambda do |pos, carry, nz_a, z_a, nz_b, z_b|
      return 0 if pos == m && carry != 0
      return (nz_a && nz_b ? 1 : 0) if pos == m

      key = [pos, carry, nz_a, z_a, nz_b, z_b]
      return @memo[key] if @memo.key?(key)

      target = digits[pos]
      count = 0

      (0..9).each do |da|
        next if z_a && da != 0 # once placed zero, can't place non-zero
        (0..9).each do |db|
          next if z_b && db != 0

          sum = da + db + carry
          next unless sum % 10 == target

          new_carry = sum / 10
          new_nz_a = nz_a || (da != 0)
          new_z_a = z_a || (da == 0)
          new_nz_b = nz_b || (db != 0)
          new_z_b = z_b || (db == 0)

          count += solve.call(pos + 1, new_carry, new_nz_a, new_z_a, new_nz_b, new_z_b)
        end
      end

      @memo[key] = count
    end

    solve.call(0, 0, false, false, false, false)
  end
end
