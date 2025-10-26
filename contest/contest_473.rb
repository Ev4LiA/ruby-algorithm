class Contest473
  # @param {Integer} n
  # @return {Integer}
  def remove_zeros(n)
    n.to_s.delete('0').to_i
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def max_alternating_sum(nums)
    squares = nums.map { |v| v * v }
    squares.sort!
    k = (nums.length + 1) / 2
    pos_sum = squares.pop(k).sum
    neg_sum = squares.sum
    pos_sum - neg_sum
  end

  # @param {Integer[]} capacity
  # @return {Integer}
  def count_stable_subarrays(capacity)
    n = capacity.length
    pref = Array.new(n + 1, 0)
    n.times { |i| pref[i + 1] = pref[i] + capacity[i] }

    store = Hash.new { |h, k| h[k] = Hash.new(0) }
    ans = 0

    n.times do |r|
      # add l = r-2 to store before processing r
      if r >= 2
        l = r - 2
        val_l = capacity[l]
        store[val_l][pref[l]] += 1
      end

      val_r = capacity[r]
      key = pref[r] - (2 * val_r)
      ans += store[val_r][key] if store.key?(val_r)
    end

    ans
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def num_good_subarrays(nums, k)
    n = nums.length

    # 1. Count all (not-necessarily-distinct) good subarrays using the classic
    #    prefix-sum-mod-k trick.
    cnt = Hash.new(0)
    cnt[0] = 1
    pref = 0
    total = 0

    nums.each do |v|
      pref = (pref + v) % k
      total += cnt[pref]
      cnt[pref] += 1
    end

    # 2. Deduct the over-count that originates from subarrays consisting of a
    #    single repeated value (duplicates can *only* appear in such segments
    #    because `nums` is non-decreasing).
    dup = 0
    i = 0
    while i < n
      j = i
      j += 1 while j < n && nums[j] == nums[i]

      c = j - i           # run length
      v = nums[i]

      g  = v.gcd(k)
      kp = k / g          # minimal length that makes (len * v) % k == 0

      if kp <= c
        m = c / kp       # how many different lengths inside this run work
        # duplicates contributed by this run for all such lengths
        #   = Σ_{t=1..m} (c - t*kp)
        dup += (m * c) - (kp * m * (m + 1) / 2)
      end

      i = j
    end

    total - dup
  end
end
