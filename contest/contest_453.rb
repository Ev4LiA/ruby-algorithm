class Contest453
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Boolean}
  def can_make_equal(nums, k)
    n = nums.length
    return true if n == 1

    # Helper function to calculate minimum operations needed for a target
    needed = lambda do |target|
      diff = Array.new(n + 1, 0)
      cur = 0
      ops = 0

      (0...n).each do |i|
        cur ^= diff[i]
        val = (cur & 1) != 0 ? -nums[i] : nums[i]

        if val != target
          return Float::INFINITY if i + 1 >= n
          ops += 1
          cur ^= 1
          diff[i + 2] ^= 1
        end
      end

      ops
    end

    # Try both possible targets: all 1s or all -1s
    min_ops_for_ones = needed.call(1)
    min_ops_for_neg_ones = needed.call(-1)

    # Return true if either target is achievable within k operations
    [min_ops_for_ones, min_ops_for_neg_ones].min <= k
  end

  # @param {Integer[]} complexity
# @return {Integer}
def count_permutations(complexity)
  n = complexity.length
  (0...n - 1).each do |i|
    if complexity[i] > complexity[i + 1]
      return 0
    end
  end
ans = 1
(2...n).each do |i|
    ans = ans * i % 1_000_000_007
  end

  ans
end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def count_partitions(nums, k)
    n = nums.length
    dp = Array.new(n + 1, 0)
    pref = Array.new(n + 1, 0)
    dp[0] = 1
    pref[0] = 1
    dg_min = []
    dg_max = []
    l = 0

    (0...n).each do |r|
      while !dg_min.empty? && nums[dg_min.last] >= nums[r]
        dg_min.pop
      end
      while !dg_max.empty? && nums[dg_max.last] <= nums[r]
        dg_max.pop
      end
      dg_min << r
      dg_max << r

      while !dg_min.empty? && !dg_max.empty? && nums[dg_max.first] - nums[dg_min.first] > k
        if dg_min.first == l
          dg_min.shift
        end
        if dg_max.first == l
          dg_max.shift
        end
        l += 1
      end

      val = pref[r] - (l ? pref[l - 1] : 0)
      val += 1_000_000_007 if val < 0
      dp[r + 1] = val
      pref[r + 1] = (pref[r] + dp[r + 1]) % 1_000_000_007
    end

    dp[n] % 1_000_000_007
  end

  # @param {String} word1
  # @param {String} word2
  # @return {Integer}
  def min_operations(word1, word2)
    n = word1.length
    cost = Array.new(n) { Array.new(n, 0) }
    (0...n).each do |i|
      (1...n).each do |j|
        cost[i][j] = calculate_cost(word1, word2, i, j)
      end
    end

    dp = Array.new(n + 1, 1_000_000_000)
    dp[n] = 0

    (n - 1).downto(0) do |i|
      best = 1_000_000_000
      (i...n).each do |j|
        best = [best, cost[i][j] + dp[j + 1]].min
      end
      dp[i] = best
    end

    dp[0]
  end

  def calculate_cost(word1, word2, l, r)
    ops_no_reverse = mismatch_cost(word1, word2, l, r, false)
    ops_reverse = mismatch_cost(word1, word2, l, r, true) + 1
    [ops_no_reverse, ops_reverse].min
  end

  def mismatch_cost(word1, word2, l, r, reverse)
    count = Array.new(26) { Array.new(26, 0) }
    mismatch = 0
    (0..r - l).each do |k|
      word1_char = reverse ? word1[r - k] : word1[l + k]
      word2_char = word2[l + k]
      if word1_char != word2_char
        mismatch += 1
        count[word1_char.ord - 'a'.ord][word2_char.ord - 'a'.ord] += 1
      end
    end

    swaps = 0
    (0...26).each do |i|
      (i + 1...26).each do |j|
        t = [count[i][j], count[j][i]].min
        swaps += t
        count[i][j] -= t
        count[j][i] -= t
      end
    end
    residual = mismatch - swaps * 2
    swaps + residual
  end
end
