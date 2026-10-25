class 2026::October::Contest525
  # Binary Digit Score
  # @param {Integer} a
  # @param {Integer} b
  # @return {Integer}
  def calculate_score(a, b)
    s1 = a.to_s(2).count("1")
    s2 = b.to_s(2).count("1")

    s1 >= s2 ? s1 * s2 : s2 / s1
  end

  # Maximize Sum After At Most K Digit Rearrangements
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def maximize_sum(nums, k)
    gains = nums.map { |x| x.digits.sort.reverse.join.to_i - x }
    nums.sum + gains.max(k).sum
  end

  # Count Frequency Staircase Subarrays
  # @param {Integer[]} nums
  # @return {Integer}
  def count_staircaes(nums)
    n = nums.size
    ans = n # every single element is a staircase (k = 1)
    cnt = Array.new(100_001, 0)
    mark = Array.new(100_001, -1)
    stamp = 0

    k = 2
    while (len = k * (k + 1) / 2) <= n
      # fill the first window
      (0...len).each { |j| cnt[nums[j]] += 1 }

      (0..n - len).each do |i|
        if i > 0
          cnt[nums[i - 1]] -= 1
          cnt[nums[i + len - 1]] += 1
        end

        # cheap filter: 1st value appears once, 2nd value appears twice
        next unless cnt[nums[i]] == 1 && cnt[nums[i + 1]] == 2

        stamp += 1
        order = 0
        ok = true
        (i...i + len).each do |j|
          v = nums[j]
          next if mark[v] == stamp

          mark[v] = stamp
          order += 1
          if cnt[v] != order
            ok = false
            break
          end
        end
        ans += 1 if ok
      end

      # clear counts for the last window
      (n - len...n).each { |j| cnt[nums[j]] = 0 }
      k += 1
    end

    ans
  end
end
