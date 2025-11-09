class Contest475
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_distance(nums)
    last = {}
    second_last = {}
    min_span = Float::INFINITY

    nums.each_with_index do |val, idx|
      if second_last.key?(val)
        span = idx - second_last[val]
        min_span = span if span < min_span
      end

      # update
      second_last[val] = last[val] if last.key?(val)
      last[val] = idx
    end

    return -1 if min_span == Float::INFINITY

    2 * min_span
  end

  # @param {Integer[][]} grid
  # @param {Integer} k
  # @return {Integer}
  def max_path_score(grid, k); end
end
