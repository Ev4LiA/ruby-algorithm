class Contest518
  # Q1. Count Rotations With Exactly K Equal Adjacent Pairs
  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def count_rotations(s, k)
    n = s.length
    total = (0...n).count { |i| s[i] == s[(i + 1) % n] }

    if k == total
      n - total
    elsif k == total - 1
      total
    else
      0
    end
  end

  # Q2. Count Good Cyclic Rotations
  # @param {Integer[]} nums
  # @return {Integer}
  def count_good_rotations(nums)
    n = nums.length
    h = n / 2
    total = nums.sum

    window = nums[0, h].sum # first-half sum for rotation starting at index 0
    count = 0
    count += 1 if 2 * window > total

    (1...n).each do |p|
      # slide: drop the element leaving the window, add the one entering
      window -= nums[p - 1]
      window += nums[(p + h - 1) % n]
      count += 1 if 2 * window > total
    end

    count
  end
end
