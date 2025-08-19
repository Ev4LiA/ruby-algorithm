class Contest463
  # @param {Integer[]} prices
  # @param {Integer[]} strategy
  # @param {Integer} k
  # @return {Integer}
  def max_profit(prices, strategy, k)
    n = prices.size
    half = k / 2

    # Base profit without modification
    base_profit = 0
    n.times { |i| base_profit += strategy[i] * prices[i] }

    # Prefix sums for prices and strategy*prices
    price_prefix = Array.new(n + 1, 0)
    orig_prefix  = Array.new(n + 1, 0)

    n.times do |i|
      price_prefix[i + 1] = price_prefix[i] + prices[i]
      orig_prefix[i + 1]  = orig_prefix[i] + (strategy[i] * prices[i])
    end

    max_delta = 0

    (0..n - k).each do |i|
      sum_second_half = price_prefix[i + k] - price_prefix[i + half]
      sum_original    = orig_prefix[i + k] - orig_prefix[i]
      delta = sum_second_half - sum_original
      max_delta = delta if delta > max_delta
    end

    base_profit + max_delta
  end

  # @param {Integer[]} nums
  # @param {Integer[][]} queries
  # @return {Integer}
  def xor_after_queries(nums, queries)
    mod = 10**9 + 7
    queries.each do |l, r, k, v|
      (l..r).step(k) do |idx|
        nums[idx] = (nums[idx] * v) % mod
      end
    end
    nums.reduce(0) { |acc, num| acc ^ num }
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def min_array_sum(nums, k)
    total = nums.sum
    n = nums.size
    mod = k

    inf_neg = -1 << 60
    best = Array.new(mod, inf_neg)

    dp = 0
    prefix = 0
    best[0] = 0 # dp - prefix for residue 0

    nums.each do |val|
      prefix += val
      residue = prefix % mod
      # candidate remove sum
      candidate = best[residue] == inf_neg ? inf_neg : best[residue] + prefix
      dp = [dp, candidate].max
      # update best for this residue after computing candidate
      best[residue] = [best[residue], dp - prefix].max
    end

    total - dp
  end

  # @param {Integer[]} nums
  # @param {Integer[][]} queries
  # @return {Integer}
  def xor_after_queries_2(nums, queries)
    mod = 10**9 + 7

    mod_pow = lambda do |a, e, m|
      res = 1
      base = a % m
      while e > 0
        res = (res * base) % m if e.odd?
        base = (base * base) % m
        e >>= 1
      end
      res
    end

    n = nums.size
    threshold = Math.sqrt(n).to_i
    small = Hash.new { |h, k| h[k] = [] }

    queries.each do |l, r, k, v|
      if k <= threshold
        small[k] << [l, r, v]
      else
        idx = l
        while idx <= r
          nums[idx] = (nums[idx] * v) % mod
          idx += k
        end
      end
    end

    small.each do |k, list|
      diff = Array.new(n + k + 1, 1)
      list.each do |l, r, v|
        diff[l] = (diff[l] * v) % mod
        inv_v = mod_pow.call(v, mod - 2, mod)
        # compute first index greater than r that shares the same residue as l
        last_included = r - ((r - l) % k)
        pos = last_included + k
        diff[pos] = (diff[pos] * inv_v) % mod if pos < diff.length
      end

      cur = Array.new(k, 1)
      (0...n).each do |i|
        r = i % k
        cur[r] = (cur[r] * diff[i]) % mod
        nums[i] = (nums[i] * cur[r]) % mod
      end
    end

    nums.reduce(0) { |acc, num| acc ^ num }
  end
end
