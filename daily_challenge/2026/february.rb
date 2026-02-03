class February2026
  # 3010. Divide an Array Into Subarrays With Minimum Cost I
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_cost(nums)
    nums[1..-1] = nums[1..-1].sort!
    nums[0] + nums[1] + nums[2]
  end

  # 3637. Tritonic Array I
  # @param {Integer[]} nums
  # @return {Boolean}
  def is_trionic(nums)
    p = 0
    n = nums.length
    p += 1 while p + 1 < n && nums[p] < nums[p + 1]
    return false if p.zero? || p == n - 1

    p += 1 while p + 1 < n && nums[p] > nums[p + 1]

    return false if p >= n - 1

    while p < n - 1
      return false if nums[p + 1] <= nums[p]

      p += 1
    end

    true
  end
end
