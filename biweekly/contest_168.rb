class Contest168
  # @param {String} s
  # @return {String}
  def lex_smallest(s)
    n = s.length
    best = nil

    1.upto(n) do |k|
      first_rev = s[0, k].reverse + s[k, n - k]
      last_rev = s[0, n - k] + s[n - k, k].reverse

      best = first_rev if best.nil? || first_rev < best
      best = last_rev if last_rev < best
    end

    best
  end

  # @param {Integer} num
  # @param {Integer} sum
  # @return {String}
  def max_sum_of_squares(num, sum)
    # feasibility check
    return "" if sum < 1 || sum > 9 * num

    digits = []
    remaining = sum
    num.times do |i|
      positions_left = num - i - 1
      # digit range for this position
      start_d = 9
      chosen = nil
      start_d.downto(0) do |d|
        next if i.zero? && d == 0

        rest = remaining - d
        next if rest < 0 || rest > 9 * positions_left

        chosen = d
        break
      end
      return "" if chosen.nil?

      digits << chosen
      remaining -= chosen
    end

    return "" unless remaining.zero?

    digits.join
  end

  # @param {Integer[]} nums1
  # @param {Integer[]} nums2
  # @return {Integer}
  def min_operations(nums1, nums2)
    n = nums1.length
    static_total = 0
    n.times { |i| static_total += (nums1[i] - nums2[i]).abs }

    last = nums2[-1]
    best = Float::INFINITY

    n.times do |i|
      a = nums1[i]
      b = nums2[i]
      range = [a, b, last].max - [a, b, last].min
      candidate = static_total - (a - b).abs + 1 + range
      best = candidate if candidate < best
    end

    best
  end

  MOD = 1_000_000_007

  def gcd(a, b)
    b.zero? ? a : gcd(b, a % b)
  end

  def count_coprime(mat)
    m = mat.length
    # frequencies per row
    dp = Hash.new(0)
    mat[0].each { |v| dp[v] += 1 }

    (1...m).each do |r|
      row_freq = Hash.new(0)
      mat[r].each { |v| row_freq[v] += 1 }
      new_dp = Hash.new(0)

      dp.each do |g, ways|
        row_freq.each do |val, cnt|
          ng = gcd(g, val)
          new_dp[ng] = (new_dp[ng] + (ways * cnt)) % MOD
        end
      end
      dp = new_dp
    end

    dp[1] % MOD
  end
end
