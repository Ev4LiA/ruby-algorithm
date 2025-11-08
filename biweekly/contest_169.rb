class Contest169
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves(nums)
    max_val = nums.max
    nums.sum { |num| max_val - num }
  end

  # @param {Integer[]} nums
  # @param {Integer} target
  # @return {Integer}
  def count_majority_subarrays(nums, target)
    n = nums.length
    count = 0

    (0...n).each do |i|
      target_count = 0
      (i...n).each do |j|
        target_count += 1 if nums[j] == target
        subarray_length = j - i + 1
        # target must appear strictly more than half the times
        # i.e., target_count > subarray_length / 2
        count += 1 if target_count * 2 > subarray_length
      end
    end

    count
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def longest_subarray(nums)
    n = nums.size
    return n if n <= 2         # one change can always fix length-2 edge cases

    left  = Array.new(n, 1)    # non-decreasing ending at i
    right = Array.new(n, 1)    # non-decreasing starting at i

    (1...n).each do |i|
      left[i] = left[i - 1] + 1 if nums[i - 1] <= nums[i]
    end

    (n - 2).downto(0) do |i|
      right[i] = right[i + 1] + 1 if nums[i] <= nums[i + 1]
    end

    ans = left.max             # zero changes

    (0...n).each do |i|
      ans = if i > 0 && i < n - 1
              if nums[i - 1] <= nums[i + 1] # splice both sides
                [ans, left[i - 1] + right[i + 1] + 1].max
              else # extend one side only
                [ans, [left[i - 1], right[i + 1]].max + 1].max
              end
            elsif i == 0                       # change first element
              [ans, 1 + right[1]].max
            else                               # change last element
              [ans, 1 + left[n - 2]].max
            end
    end

    ans
  end

  # @param {Integer[]} nums
  # @param {Integer} target
  # @return {Integer}
  def count_majority_subarrays_2(nums, target)

  end
end
