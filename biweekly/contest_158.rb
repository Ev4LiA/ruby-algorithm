class Contest158
  MIN_NUMBER = -(10**18)

  # @param {Integer[]} x
  # @param {Integer[]} y
  # @return {Integer}
  def max_sum_distinct_triplet(x, y)
    x_to_max_y = {}

    x.each_with_index do |x_val, i|
      if x_to_max_y[x_val].nil? || y[i] > x_to_max_y[x_val]
        x_to_max_y[x_val] = y[i]
      end
    end

    return -1 if x_to_max_y.size < 3

    max_y_values = x_to_max_y.values.sort.reverse[0..2]

    max_y_values.sum
  end

  # @param {Integer[]} prices
  # @param {Integer} k
  # @return {Integer}
  def maximum_profit(prices, k)
    free = Array.new(k + 1, MIN_NUMBER)
    long_pos = Array.new(k + 1, MIN_NUMBER)
    short_pos = Array.new(k + 1, MIN_NUMBER)
    free[0] = 0

    prices.each do |price|
      prev_free = free.dup
      prev_long = long_pos.dup
      prev_short = short_pos.dup

      (0..k).each do |i|
        if prev_free[i] != MIN_NUMBER
          long_pos[i] = [long_pos[i], prev_free[i] - price].max
          short_pos[i] = [short_pos[i], prev_free[i] + price].max
        end
        if i > 0
          if prev_long[i - 1] != MIN_NUMBER
            free[i] = [free[i], prev_long[i - 1] + price].max
          end
          if prev_short[i - 1] != MIN_NUMBER
            free[i] = [free[i], prev_short[i - 1] - price].max
          end
        end
      end
    end
    free.max
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def max_gcd_score(nums, k)
    n = nums.length
    ans = 0

    (0...n).each do |i|
      (i...n).each do |j|
        subarray = nums[i..j]
        length = j - i + 1

        score = calculate_max_score(subarray, k)
        ans = [ans, length * score].max
      end
    end

    ans
  end

  private

  def calculate_max_score(arr, k)
    odd_parts = []
    powers_of_2 = []

    arr.each do |num|
      odd_part = num
      power = 0
      while odd_part & 1 == 0
        odd_part >>= 1
        power += 1
      end
      odd_parts << odd_part
      powers_of_2 << power
    end

    base_gcd = odd_parts.reduce(:gcd)

    min_power = powers_of_2.min

    count_min_power = powers_of_2.count(min_power)

    operations_used = [k, count_min_power].min

    if operations_used == count_min_power && count_min_power <= k
      final_power = min_power + 1
    else
      final_power = min_power
    end

    base_gcd * (2 ** final_power)
  end
end
