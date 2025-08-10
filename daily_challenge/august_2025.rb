class August2025
  # 118. Pascal's Triangle
  # @param {Integer} num_rows
  # @return {Integer[][]}
  def generate(num_rows)
    return [[1]] if num_rows == 1
    return [[1], [1, 1]] if num_rows == 2

    res = [[1], [1, 1]]
    (3..num_rows).each do |i|
      prev_row = res[i - 2]
      row = [1]
      (0...prev_row.size - 1).each do |j|
        row << (prev_row[j] + prev_row[j + 1])
      end
      row << 1
      res << row
    end
    res
  end

  # 2561. Rearranging Fruits
  # @param {Integer[]} basket1
  # @param {Integer[]} basket2
  # @return {Integer}
  def min_cost(basket1, basket2)
    freq = basket1.tally
    basket2.each do |fruit|
      freq[fruit] ||= 0
      freq[fruit] -= 1
    end

    min_element = [basket1.min, basket2.min].min

    merge = []
    freq.each do |fruit, count|
      return -1 if count.odd?

      (0...count.abs / 2).each do |_|
        merge << fruit
      end
    end

    merge.sort!
    res = 0
    (0...merge.size / 2).each do |i|
      res += [merge[i], 2 * min_element].min
    end
    res
  end

  # 2106. Maximum Fruits Harvested After at Most K Steps
  # @param {Integer[][]} fruits
  # @param {Integer} start_pos
  # @param {Integer} k
  # @return {Integer}
  def max_total_fruits(fruits, start_pos, k)
    n = fruits.size
    sum = Array.new(n + 1, 0)
    indices = Array.new(n)
    sum[0] = 0
    (0...n).each do |i|
      sum[i + 1] = sum[i] + fruits[i][1]
      indices[i] = fruits[i][0]
    end
    ans = 0
    (0..k / 2).each do |x|
      y = k - (2 * x)
      left = start_pos - x
      right = start_pos + y
      start = lower_bound(indices, 0, n - 1, left)
      end_1 = upper_bound(indices, 0, n - 1, right)
      ans = [ans, sum[end_1] - sum[start]].max

      y = k - (2 * x)
      left = start_pos - y
      right = start_pos + x
      start = lower_bound(indices, 0, n - 1, left)
      end_2 = upper_bound(indices, 0, n - 1, right)
      ans = [ans, sum[end_2] - sum[start]].max
    end
    ans
  end

  def lower_bound(arr, left, right, val)
    res = right + 1
    while left <= right
      mid = left + ((right - left) / 2)
      if arr[mid] < val
        left = mid + 1
      else
        res = mid
        right = mid - 1
      end
    end
    res
  end

  def upper_bound(arr, left, right, val)
    res = right + 1
    while left <= right
      mid = left + ((right - left) / 2)
      if arr[mid] <= val
        left = mid + 1
      else
        res = mid
        right = mid - 1
      end
    end
    res
  end
  su
  # Second methods (using sliding window)
  def max_total_fruits_sliding_window(fruits, start_pos, k)
    left = 0
    right = 0
    n = fruits.length
    sum = 0
    ans = 0
    step = lambda do |fruits, start_pos, left, right|
      [(start_pos - fruits[right][0]).abs, (start_pos - fruits[left][0]).abs].min + fruits[right][0] - fruits[left][0]
    end

    while right < n
      sum += fruits[right][1]

      while left <= right && step.call(fruits, start_pos, left, right) > k
        sum -= fruits[left][1]
        left += 1
      end

      ans = [ans, sum].max
      right += 1
    end
    ans
  end

  # 3477. Fruits Into Baskets II
  # @param {Integer[]} fruits
  # @param {Integer[]} baskets
  # @return {Integer}
  def num_of_unplaced_fruits(fruits, baskets)
    count = 0
    n = baskets.size

    fruits.each do |fruit|
      placed = false
      (0...n).each do |i|
        next unless baskets[i] >= fruit

        baskets[i] = 0
        placed = true
        break
      end
      count += 1 unless placed
    end
    count
  end

  # 3479. Fruits Into Baskets III
  # @param {Integer[]} fruits
  # @param {Integer[]} baskets
  # @return {Integer}
  def num_of_unplaced_fruits_iii(fruits, baskets)
    n = baskets.size
    m = Math.sqrt(n).to_i

    sections = (n + m - 1) / m
    count = 0

    max_v = Array.new(sections) { 0 }

    (0...n).each { |i| max_v[i / m] = [max_v[i / m], baskets[i]].max }

    fruits.each do |fruit|
      un_set = true
      (0...sections).each do |section|
        next if max_v[section] < fruit

        choose = false
        max_v[section] = 0
        (0...m).each do |j|
          pos = (section * m) + j
          if pos < n && baskets[pos] >= fruit && !choose
            baskets[pos] = 0
            choose = true
          end

          max_v[section] = [max_v[section], baskets[pos]].max if pos < n
        end

        un_set = false
        break
      end
      count += 1 if un_set
    end

    count
  end

  # 3363. Find the Maximum Number of Fruits Collected
  # @param {Integer[][]} fruits
  # @return {Integer}
  def max_collected_fruits(fruits)
    n = fruits.length
    ans = 0
    (0...n).each { |i| ans += fruits[i][i] }

    infinity_neg = -Float::INFINITY

    dp = lambda do
      prev = Array.new(n, infinity_neg)
      curr = Array.new(n, infinity_neg)
      prev[n - 1] = fruits[0][n - 1]

      (1...(n - 1)).each do |i|
        start_j = [n - 1 - i, i + 1].max
        (start_j...n).each do |j|
          best = prev[j]
          best = [best, prev[j - 1]].max if j - 1 >= 0
          best = [best, prev[j + 1]].max if j + 1 < n
          curr[j] = best + fruits[i][j]
        end
        prev = curr
        curr = Array.new(n, infinity_neg)
      end

      prev[n - 1]
    end

    ans += dp.call

    # Transpose matrix in-place (upper triangle to lower)
    (0...n).each do |i|
      (0...i).each do |j|
        fruits[i][j], fruits[j][i] = fruits[j][i], fruits[i][j]
      end
    end

    ans += dp.call
    ans
  end

  # 808. Soup Servings
  # @param {Integer} n
  # @return {Float}
  def soup_servings(n)
    # For very large n, probability approaches 1
    return 1.0 if n > 4800

    m = (n.to_f / 25).ceil
    dp = Hash.new { |h, k| h[k] = {} }

    calculate_dp = nil
    calculate_dp = lambda do |i, j|
      return 0.5 if i <= 0 && j <= 0
      return 1.0 if i <= 0
      return 0.0 if j <= 0
      return dp[i][j] if dp[i].key?(j)

      res = (
        calculate_dp.call(i - 4, j) +
        calculate_dp.call(i - 3, j - 1) +
        calculate_dp.call(i - 2, j - 2) +
        calculate_dp.call(i - 1, j - 3)
      ) / 4.0
      dp[i][j] = res
      res
    end

    (1..m).each do |k|
      return 1.0 if calculate_dp.call(k, k) > 1 - 1e-5
    end

    calculate_dp.call(m, m)
  end

  # 231. Power of Two
  # @param {Integer} n
  # @return {Boolean}
  def is_power_of_two(n)
    return false if n <= 0

    (n & (n - 1)).zero?
  end

  # 869. Reordered Power of 2
  # @param {Integer} n
  # @return {Boolean}
  def reordered_power_of2(n)
    n_str = n.to_s.chars.sort.join
    31.times do |i|
      power_of_2 = 2**i
      power_of_2_str = power_of_2.to_s.chars.sort.join
      return true if power_of_2_str == n_str
    end
    false
  end
end
