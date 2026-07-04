class Contest186
  # @param {Integer[]} nums
  # @return {Boolean}
  def is_middle_element_unique(nums)
    n = nums.length
    middle_value = nums[n / 2]

    nums.count(middle_value) == 1
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def max_valid_pair_sum(nums, k)
    n = nums.length

    # best value of nums[i] for i <= j - k
    best_prefix = nums[0]
    answer = -Float::INFINITY

    (k...n).each do |j|
      # i can be from 0 to j - k, we keep the max of that range
      answer = [answer, best_prefix + nums[j]].max
      best_prefix = [best_prefix, nums[j - k + 1]].max if j - k + 1 < n
    end

    answer
  end

  # @param {String} s1
  # @param {String} s2
  # @return {Integer}
  def min_operations(s1, s2); end
end
