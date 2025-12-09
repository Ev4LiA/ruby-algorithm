class December2025
  # 3623. Count Number of Trapezoids I
  # @param {Integer[][]} points
  # @return {Integer}
  def count_trapezoids(points)
    point_num = Hash.new(0)
    mod = (10**9) + 7
    ans = 0
    sum = 0
    points.each do |point|
      point_num[point[1]] += 1
    end

    point_num.each_value do |p_num|
      edge = ((p_num * (p_num - 1)) / 2) % mod
      ans = (ans + (edge * sum)) % mod
      sum = (sum + edge) % mod
    end

    ans
  end

  # 3625. Count Number of Trapezoids II
  # @param {Integer[][]} points
  # @return {Integer}
  def count_trapezoids2(points)
    mod = (10**9) + 7
    slope_to_intercept = Hash.new { |h, k| h[k] = [] }
    mid_to_slope = Hash.new { |h, k| h[k] = [] }
    ans = 0
    n = points.length
    (0...n).each do |i|
      x1 = points[i][0]
      y1 = points[i][1]
      (i + 1...n).each do |j|
        x2 = points[j][0]
        y2 = points[j][1]
        dx = x1 - x2
        dy = y1 - y2
        k = 0
        b = 0

        if x2 == x1
          k = mod
          b = x1
        else
          k = (1.0 * (y2 - y1)) / (x2 - x1)
          b = (1.0 * ((y1 * dx) - (x1 * dy))) / dx
        end

        k = 0.0 if k == -0.0
        b = 0.0 if b == -0.0
        mid = ((x1 + x2) * 10_000) + (y1 + y2)
        slope_to_intercept[k] << b
        mid_to_slope[mid] << k
      end
    end

    slope_to_intercept.each_value do |sti|
      next if sti.size == 1

      cnt = Hash.new(0)
      sti.each do |b|
        cnt[b] += 1
      end
      sum = 0
      cnt.each_value do |count|
        ans += sum * count
        sum += count
      end
    end

    mid_to_slope.each_value do |mts|
      next if mts.size == 1

      cnt = Hash.new(0)
      mts.each do |k|
        cnt[k] += 1
      end
      sum = 0
      cnt.each_value do |count|
        ans -= sum * count
        sum += count
      end
    end

    ans
  end

  # 2211. Count Collisions on a Road
  # @param {String} directions
  # @return {Integer}
  def count_collisions(directions)
    res = 0
    l = 0
    n = directions.length
    r = n - 1

    l += 1 while l < n && directions[l] == "L"
    r -= 1 while r >= 0 && directions[r] == "R"

    (l..r).each do |i|
      res += 1 if directions[i] != "S"
    end
    res
  end

  # 3432. Count Partitions with Even Sum Difference
  # @param {Integer[]} nums
  # @return {Integer}
  def count_partitions_with_even_sum_difference(nums)
    nums.sum.even? ? nums.length - 1 : 0
  end

  # 3578. Count Partitions With Max-Min Difference at Most K
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def count_partitions(nums, k)
    n = nums.length
    mod = (10**9) + 7
    dp = Array.new(n + 1, 0)
    prefix = Array.new(n + 1, 0)
    cnt = Hash.new(0)

    dp[0] = 1
    prefix[0] = 1
    j = 0

    (0...n).each do |i|
      cnt[nums[i]] += 1
      while j <= i && cnt.keys.max - cnt.keys.min > k
        cnt[nums[j]] -= 1
        cnt.delete(nums[j]) if cnt[nums[j]].zero?
        j += 1
      end
      dp[i + 1] = (prefix[i] - (j.positive? ? prefix[j - 1] : 0) + mod) % mod
      prefix[i + 1] = (prefix[i] + dp[i + 1]) % mod
    end
    dp[n]
  end

  def count_partitions2(nums, k)
    n = nums.length
    mod = (10**9) + 7
    dp = Array.new(n + 1, 0)
    prefix = Array.new(n + 1, 0)

    min_q = [] # deque of indices for minimums (increasing values)
    max_q = [] # deque of indices for maximums (decreasing values)

    dp[0] = 1
    prefix[0] = 1

    j = 0
    (0...n).each do |i|
      # maintain max deque (values decreasing)
      max_q.pop while !max_q.empty? && nums[max_q[-1]] <= nums[i]
      max_q << i

      # maintain min deque (values increasing)
      min_q.pop while !min_q.empty? && nums[min_q[-1]] >= nums[i]
      min_q << i

      # adjust window so max - min <= k
      while !max_q.empty? && !min_q.empty? && (nums[max_q[0]] - nums[min_q[0]] > k)
        max_q.shift if max_q[0] == j
        min_q.shift if min_q[0] == j
        j += 1
      end

      left_prefix = j > 0 ? prefix[j - 1] : 0
      dp[i + 1] = (prefix[i] - left_prefix) % mod
      dp[i + 1] += mod if dp[i + 1] < 0
      prefix[i + 1] = (prefix[i] + dp[i + 1]) % mod
    end

    dp[n]
  end

  # 1925. Count Square Sum Triples
  # @param {Integer} n
  # @return {Integer}
  def count_triples(n)
    target = Hash.new(0)
    (1..n).each do |i|
      target[i * i] += 1
    end

    count = 0
    (1..n).each do |a|
      (1..n).each do |b|
        count += 1 if target.include?(a * a + b * b)
      end
    end
    count
  end

  # 3583. Count Special Triplets
  # @param {Integer[]} nums
  # @return {Integer}
  def special_triplets(nums)
    n = nums.length
    count = 0
    mod = (10**9) + 7

    total_freq = Hash.new(0)
    nums.each { |num| total_freq[num] += 1 }
    left_freq = Hash.new(0)

    (0...n).each do |j|
      target = nums[j] * 2
      right_freq = total_freq[target] - left_freq[target]
      right_freq -= 1 if nums[j] == target
      count = (count + (left_freq[target] * right_freq)) % mod
      left_freq[nums[j]] += 1
    end

    count
  end
end
