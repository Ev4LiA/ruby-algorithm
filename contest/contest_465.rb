class Contest465
  # @param {Integer[]} order
  # @param {Integer[]} friends
  # @return {Integer[]}
  def recover_order(order, friends)
    friend_set = friends.to_h { |id| [id, true] }
    order.select { |id| friend_set[id] }
  end

  # @param {Integer} n
  # @param {Integer} k
  # @return {Integer[]}
  def min_difference(n, k)
    # Helper to list all positive divisors of a number in non-decreasing order.
    divisors_cache = Hash.new do |h, key|
      list = []
      1.upto(Math.sqrt(key).to_i) do |d|
        next unless (key % d).zero?

        list << d
        other = key / d
        list << other unless other == d
      end
      h[key] = list.sort
    end

    best_split = nil
    best_range = Float::INFINITY

    dfs = lambda do |remaining, start_factor, factors_left, current|
      if factors_left == 1
        # The last factor is forced to be the remaining number.
        return if remaining < start_factor # maintain non-decreasing order

        arr = current + [remaining]
        range = arr.max - arr.min
        if range < best_range
          best_range = range
          best_split = arr.dup
        end
        return
      end

      divisors_cache[remaining].each do |d|
        next if d < start_factor # ensure non-decreasing order
        next if (remaining % d).nonzero?

        dfs.call(remaining / d, d, factors_left - 1, current + [d])
      end
    end

    dfs.call(n, 1, k, [])

    best_split || []
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def max_product(nums)
    return 0 if nums.size < 2

    # Numbers are <= 1e6, so 20 bits are sufficient (2^20 > 1e6)
    bits = 20
    size = 1 << bits

    # top[mask] = largest number encountered with exact mask
    top = Array.new(size, 0)

    nums.each do |x|
      mask = x
      top[mask] = x if x > top[mask]
    end

    # SOS DP (subset DP): for each mask, propagate the maximum value of its subsets
    bits.times do |i|
      (0...size).each do |mask|
        next if (mask & (1 << i)).zero?

        subset = mask ^ (1 << i)
        top[mask] = top[subset] if top[subset] > top[mask]
      end
    end

    full_mask = size - 1
    best = 0

    (0...size).each do |mask|
      a = top[mask]
      next if a.zero?

      complement = full_mask ^ mask
      b = top[complement]
      next if b.zero?

      product = a * b
      best = product if product > best
    end

    best
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def total_beauty(nums)
    mod = 1_000_000_007
    n = nums.length

    dp = Array.new(n) { Hash.new(0) } # dp[i]: gcd -> count for subsequences ending at i
    total = Hash.new(0)               # global gcd -> total count

    nums.each_with_index do |x, i|
      here = Hash.new(0)
      here[x] = 1                    # single element subsequence

      (0...i).each do |j|
        next if nums[j] >= x         # maintain strictly increasing

        dp[j].each do |g, cnt|
          ng = g.gcd(x)
          here[ng] = (here[ng] + cnt) % mod
        end
      end

      here.each { |g, cnt| total[g] = (total[g] + cnt) % mod }
      dp[i] = here
    end

    ans = 0
    total.each do |g, cnt|
      term = (g * cnt) % mod
      ans = (ans + term) % mod
    end

    ans
  end
end
