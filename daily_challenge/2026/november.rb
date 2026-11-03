class November2026
  # 453. Minimum Moves to Equal Array Elements
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves(nums)
    nums.sum - (nums.min * nums.size)
  end

  # 462. Minimum Moves to Equal Array Elements II
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves2(nums)
    nums.sort!
    median = nums[nums.size / 2]
    nums.sum { |x| (x - median).abs }
  end

  # 3736. Minimum Moves to Equal Array Elements III
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves3(nums)
    max = nums.max
    (max * nums.size) - nums.sum
  end
end
