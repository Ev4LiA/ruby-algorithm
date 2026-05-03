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
      f += sum - (n * nums[n - k])
      max_f = [max_f, f].max
    end
    max_f
  end

  # 788. Rotated Digits
  # @param {Integer} n
  # @return {Integer}
  def rotated_digits(n)
    count = 0
    (1..n).each do |i|
      s = i.to_s
      next if s.include?("3") || s.include?("4") || s.include?("7")

      count += 1 if s.include?("2") || s.include?("5") || s.include?("6") || s.include?("9")
    end
    count
  end

  # 796. Rotate String
  # @param {String} s
  # @param {String} goal
  # @return {Boolean}
  def rotate_string(s, goal)
    return false if s.length != goal.length

    (s + s).include?(goal)
  end
end
