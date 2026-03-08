class Contest492
  # @param {Integer[]} capacity
  # @param {Integer} item_size
  # @return {Integer}
  def minimum_index(capacity, item_size)
    max = Float::INFINITY
    res = -1

    capacity.each_with_index do |cap, index|
      if cap >= item_size && cap < max
        max = cap
        res = index
      end
    end

    res
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def smallest_balanced_index(nums)
    n = nums.length

    total_sum = nums.sum
    cap = total_sum + 1

    right_prods = Array.new(n)
    right_prods[n - 1] = 1

    (n - 2).downto(0) do |i|
      prod = right_prods[i + 1] * nums[i + 1]
      right_prods[i] = prod >= cap ? cap : prod
    end

    left_sum = 0
    (0...n).each do |i|
      return i if left_sum == right_prods[i]

      left_sum += nums[i]
    end

    -1
  end
end
