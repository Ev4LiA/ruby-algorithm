class May2026
  # 396. Rotate Function
  # @param {Integer[]} nums
  # @return {Integer}
  def max_rotate_function(nums)
    n = nums.length
    sum = nums.sum
    f = 0
    (0...n).each { |i| f += i * nums[i] }
    max_f = f
    (1...n).each do |k|
      f += sum - n * nums[n - k]
      max_f = [max_f, f].max
    end
    max_f
  end
end
