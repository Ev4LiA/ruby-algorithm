class Contest178
  # @param {Integer[]} nums
  # @return {Integer}
  def first_unique_even(nums)
    count = Hash.new(0)

    nums.each do |num|
      count[num] += 1 if num.even?
    end

    nums.each do |num|
      return num if num.even? && count[num] == 1
    end

    -1
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def gcd_sum(nums)
    n = nums.length
    prefix_gcd = []
    mxi = 0

    nums.each do |num|
      mxi = [mxi, num].max
      prefix_gcd << gcd(num, mxi)
    end

    prefix_gcd.sort!

    sum = 0
    left = 0
    right = n - 1

    while left < right
      sum += gcd(prefix_gcd[left], prefix_gcd[right])
      left += 1
      right -= 1
    end

    sum
  end

  # @param {Integer[]} nums1
  # @param {Integer[]} nums2
  # @return {Integer}
  def min_cost(nums1, nums2)
    counts1 = nums1.tally
    counts2 = nums2.tally

    total_counts = counts1.merge(counts2) { |_, v1, v2| v1 + v2 }

    total_counts.each_value do |count|
      return -1 if count.odd?
    end

    target_counts = total_counts.transform_values { |v| v / 2 }

    cost = 0
    counts1.each do |num, count|
      target = target_counts.fetch(num, 0)
      cost += count - target if count > target
    end

    cost
  end

  # @param {Integer} l
  # @param {Integer} r
  # @return {Integer}
  def count_fancy(l, r)
    solve_fancy(r) - solve_fancy(l - 1)
  end

  private # Fancy counting helpers are private below

  def solve_fancy(n)
    return 0 if n <= 0

    @s_fancy = n.to_s
    @n_fancy = @s_fancy.length
    @good_sums_fancy = Set.new((1..(@n_fancy * 9)).filter { |i| is_good_fancy?(i) })

    good = count_good_fancy
    sum_good = count_sum_is_good_fancy
    both_good = count_good_and_sum_is_good_fancy

    good + sum_good - both_good
  end

  def is_good_fancy?(k)
    s = k.to_s
    return true if s.length <= 1

    is_inc = (1...s.length).all? { |i| s[i] > s[i - 1] }
    return true if is_inc

    (1...s.length).all? { |i| s[i] < s[i - 1] }
  end

  def count_good_fancy
    @memo_good_fancy = {}
    dp_good_fancy(0, true, 10, true, true)
  end

  def dp_good_fancy(idx, tight, prev_digit, is_inc, is_dec)
    return prev_digit != 10 && (is_inc || is_dec) ? 1 : 0 if idx == @n_fancy

    key = [idx, tight, prev_digit, is_inc, is_dec]
    return @memo_good_fancy[key] if @memo_good_fancy.key?(key)

    res = 0
    limit = tight ? @s_fancy[idx].to_i : 9

    (0..limit).each do |digit|
      new_tight = tight && (digit == limit)
      if prev_digit == 10 # Not started yet
        res += if digit == 0
                 dp_good_fancy(idx + 1, new_tight, 10, true, true)
               else
                 dp_good_fancy(idx + 1, new_tight, digit, true, true)
               end
      else # Started
        new_inc = is_inc && (digit > prev_digit)
        new_dec = is_dec && (digit < prev_digit)
        res += dp_good_fancy(idx + 1, new_tight, digit, new_inc, new_dec) if new_inc || new_dec
      end
    end
    @memo_good_fancy[key] = res
  end

  def count_sum_is_good_fancy
    @memo_sum_good_fancy = {}
    dp_sum_good_fancy(0, true, 0, false)
  end

  def dp_sum_good_fancy(idx, tight, sum, started)
    return started && @good_sums_fancy.include?(sum) ? 1 : 0 if idx == @n_fancy

    key = [idx, tight, sum, started]
    return @memo_sum_good_fancy[key] if @memo_sum_good_fancy.key?(key)

    res = 0
    limit = tight ? @s_fancy[idx].to_i : 9

    (0..limit).each do |digit|
      new_tight = tight && (digit == limit)
      res += if !started && digit == 0
               dp_sum_good_fancy(idx + 1, new_tight, 0, false)
             else
               dp_sum_good_fancy(idx + 1, new_tight, sum + digit, true)
             end
    end
    @memo_sum_good_fancy[key] = res
  end

  def count_good_and_sum_is_good_fancy
    @memo_both_fancy = {}
    dp_both_fancy(0, true, 10, true, true, 0)
  end

  def dp_both_fancy(idx, tight, prev_digit, is_inc, is_dec, sum)
    if idx == @n_fancy
      return prev_digit != 10 && (is_inc || is_dec) && @good_sums_fancy.include?(sum) ? 1 : 0
    end

    key = [idx, tight, prev_digit, is_inc, is_dec, sum]
    return @memo_both_fancy[key] if @memo_both_fancy.key?(key)

    res = 0
    limit = tight ? @s_fancy[idx].to_i : 9

    (0..limit).each do |digit|
      new_tight = tight && (digit == limit)
      if prev_digit == 10 # Not started
        res += if digit == 0
                 dp_both_fancy(idx + 1, new_tight, 10, true, true, 0)
               else
                 dp_both_fancy(idx + 1, new_tight, digit, true, true, digit)
               end
      else # Started
        new_inc = is_inc && (digit > prev_digit)
        new_dec = is_dec && (digit < prev_digit)
        res += dp_both_fancy(idx + 1, new_tight, digit, new_inc, new_dec, sum + digit) if new_inc || new_dec
      end
    end
    @memo_both_fancy[key] = res
  end

  def gcd(a, b)
    b.zero? ? a : gcd(b, a % b)
  end
end
