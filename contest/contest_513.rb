class Contest513
  # Maximize Pair Strength Using GCD
  # @param {Integer[]} nums
  # @return {Integer}
  def max_pair_strength(nums)
    best = 0
    n = nums.length
    (0...n).each do |i|
      (i + 1...n).each do |j|
        g = nums[i].gcd(nums[j])
        strength = nums[i] * nums[j] / (g * g)
        best = strength if strength > best
      end
    end
    best
  end

  # Count Subarrays With Even Odd Ratio I
  # @param {Integer[]} nums
  # @param {Integer} a
  # @param {Integer} b
  # @return {Integer}
  def count_ratio_subarrays(nums, a, b)
    count = 0
    n = nums.length
    (0...n).each do |i|
      x = 0  # even count
      y = 0  # odd count
      (i...n).each do |j|
        if nums[j].even?
          x += 1
        else
          y += 1
        end
        count += 1 if y > 0 && x * b <= y * a
      end
    end
    count
  end
end
