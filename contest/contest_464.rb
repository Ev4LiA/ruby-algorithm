class Contest464
  # @param {Integer} n
  # @return {Integer}
  def gcd_of_odd_even_sums(n)
    n # GCD(n², n(n + 1)) = n × GCD(n, n + 1) = n
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Boolean}
  def partition_array(nums, k)
    n = nums.size
    return false unless (n % k).zero?

    groups = n / k
    counts = Hash.new(0)
    nums.each { |v| counts[v] += 1 }

    counts.values.all? { |c| c <= groups }
  end

  # @param {Integer[]} nums
  # @return {Integer[]}
  def max_value(nums)
    n = nums.size
    return nums.dup if n <= 1

    # Build prefix maximums
    pre_max = Array.new(n)
    cur_max = -Float::INFINITY
    nums.each_with_index do |v, idx|
      cur_max = v if v > cur_max
      pre_max[idx] = cur_max
    end

    # Coordinate compression
    sorted_vals = nums.uniq.sort
    index_map = {}
    sorted_vals.each_with_index { |v, idx| index_map[v] = idx + 1 } # 1-based for BIT

    size = sorted_vals.size
    bit = Array.new(size + 2, -Float::INFINITY) # Fenwick tree storing max

    update = lambda do |i, val|
      while i < bit.length
        bit[i] = val if val > bit[i]
        i += i & -i
      end
    end

    query = lambda do |i|
      res = -Float::INFINITY
      while i > 0
        res = bit[i] if bit[i] > res
        i -= i & -i
      end
      res
    end

    ans = Array.new(n)

    # iterate from right to left
    (n - 1).downto(0) do |i|
      val_idx = index_map[nums[i]]
      best_from_right = query.call(val_idx - 1)
      best_from_left = i.positive? ? pre_max[i - 1] : -Float::INFINITY
      ans[i] = [nums[i], best_from_left, best_from_right].max

      # insert current value info for positions to the left
      update_val = best_from_left
      update.call(val_idx, update_val) if i.positive? # only meaningful when there is left side
    end

    ans
  end

  # @param {Integer[]} robots
  # @param {Integer[]} distance
  # @param {Integer[]} walls
  # @return {Integer}
  def max_walls(robots, distance, walls)
    m = robots.size
    return 0 if walls.empty?

    # sort robots by position while keeping distances aligned
    idxs = (0...m).to_a.sort_by { |i| robots[i] }
    r = idxs.map { |i| robots[i] }
    d = idxs.map { |i| distance[i] }

    # sort walls once
    walls_sorted = walls.sort

    # quick helper to count walls in inclusive range [l, r] (excluding if l>r)
    count_between = lambda do |lft, rgt|
      return 0 if lft > rgt
      # first index with val >= lft
      left_idx = walls_sorted.bsearch_index { |x| x >= lft }
      return 0 unless left_idx
      # first index with val > rgt
      right_idx = walls_sorted.bsearch_index { |x| x > rgt }
      right_idx = (right_idx ? right_idx - 1 : walls_sorted.size - 1)
      return 0 if right_idx < left_idx
      right_idx - left_idx + 1
    end

    # walls that share position with robots are always destroyed
    walls_set = walls_sorted.to_h { |w| [w, true] }
    walls_at_robot = r.count { |pos| walls_set[pos] }

    # dp arrays: [left, right] orientation for current robot
    dp_left = 0
    dp_right = 0

    # handle first robot base counts (excluding its own position)
    left_start = r[0] - d[0]
    left_end = r[0] - 1
    base_left_first = count_between.call(left_start, left_end)
    dp_left = base_left_first
    dp_right = 0 # no walls yet for shooting right; handled in first gap

    # iterate gaps between robots
    (0...m - 1).each do |i|
      # gap is (r[i], r[i+1])
      # robot i shooting right interval (exclude robot positions)
      right_start = r[i] + 1
      right_end = [r[i] + d[i], r[i + 1] - 1].min
      a = count_between.call(right_start, right_end)

      # robot i+1 shooting left interval
      left_start2 = [r[i + 1] - d[i + 1], r[i] + 1].max
      left_end2 = r[i + 1] - 1
      b = count_between.call(left_start2, left_end2)

      # overlap between the two intervals
      inter_start = [right_start, left_start2].max
      inter_end = [right_end, left_end2].min
      c = count_between.call(inter_start, inter_end)

      # contributions based on orientations
      # precompute transitions
      next_left = [
        dp_left + b,                   # prev left -> curr left (only B)
        dp_right + a + b - c           # prev right -> curr left (A+B-C)
      ].max

      next_right = [
        dp_left,                       # prev left -> curr right (no walls from gap)
        dp_right + a                   # prev right -> curr right (A)
      ].max

      dp_left, dp_right = next_left, next_right
    end

    # handle last robot shooting right outside
    right_start_final = r[-1] + 1
    right_end_final = r[-1] + d[-1]
    base_right_last = count_between.call(right_start_final, right_end_final)

    total = walls_at_robot + [dp_left, dp_right + base_right_last].max
    total
  end
end
