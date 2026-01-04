class Contest173
  # @param {String} s
  # @param {Integer} k
  # @return {String}
  def reverse_prefix(s, k)
    return s if k.zero?

    s[0...k].reverse + s[k..]
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def min_length(nums, k)
    min_len = Float::INFINITY
    left = 0
    distinct_sum = 0
    window_counts = Hash.new(0)

    (0...nums.length).each do |right|
      num = nums[right]
      distinct_sum += num unless window_counts[num].positive?
      window_counts[num] += 1

      while distinct_sum >= k
        min_len = [min_len, right - left + 1].min
        left_num = nums[left]
        window_counts[left_num] -= 1
        distinct_sum -= left_num if window_counts[left_num].zero?
        left += 1
      end
    end

    min_len == Float::INFINITY ? -1 : min_len
  end

  # @param {Integer} n
  # @param {Integer[][]} restrictions
  # @param {Integer[]} diff
  # @return {Integer}
  def find_largest_value(n, restrictions, diff)
    res_map = restrictions.to_h
    a = Array.new(n)

    a[0] = 0
    (1...n).each do |i|
      a[i] = res_map.fetch(i, Float::INFINITY)
    end

    # Left to right pass
    (0...n - 1).each do |i|
      a[i + 1] = [a[i + 1], a[i] + diff[i]].min
    end

    # Right to left pass
    (n - 2).downto(0).each do |i|
      a[i] = [a[i], a[i + 1] + diff[i]].min
    end

    a.max
  end

  def number_of_routes(grid, d)
    n = grid.length
    m = grid[0].length
    mod = (10**9) + 7

    if n == 1
      available_cols = []
      (0...m).each { |c| available_cols << c if grid[0][c] == "." }

      k = available_cols.length
      return 0 if k == 0

      # Routes of length 1
      num_routes = k

      # Routes of length 2 (one horizontal move)
      pair_count = 0
      right = 0
      (0...k).each do |left|
        right = [right, left + 1].max
        right += 1 while right < k && available_cols[right] - available_cols[left] <= d
        pair_count += right - (left + 1)
      end

      num_routes = (num_routes + (2 * pair_count))
      return num_routes % mod
    end

    dp = Array.new(n) { Array.new(m) { [0, 0] } }

    # Base case: row n-1
    (0...m).each do |c|
      dp[n - 1][c][0] = 1 if grid[n - 1][c] == "."
    end

    # DP from row n-2 up to 0
    # rubocop: disable Metrics/BlockLength
    (n - 2).downto(0).each do |r|
      # Calculate dp[r][...][0]
      total_from_below = (0...m).map { |c| (dp[r + 1][c][0] + dp[r + 1][c][1]) % mod }
      prefix_sum_below = Array.new(m, 0)
      prefix_sum_below[0] = total_from_below[0]
      (1...m).each { |c| prefix_sum_below[c] = (prefix_sum_below[c - 1] + total_from_below[c]) % mod }

      max_col_diff_vert = d > 0 ? Math.sqrt((d * d) - 1).floor : -1

      (0...m).each do |c|
        next unless grid[r][c] == "." && max_col_diff_vert >= 0

        c_start = [0, c - max_col_diff_vert].max
        c_end = [m - 1, c + max_col_diff_vert].min
        sum = prefix_sum_below[c_end]
        sum -= prefix_sum_below[c_start - 1] if c_start > 0
        dp[r][c][0] = (sum + mod) % mod
      end

      # Calculate dp[r][...][1]
      just_moved_up = (0...m).map { |c| dp[r][c][0] }
      prefix_sum_up = Array.new(m, 0)
      prefix_sum_up[0] = just_moved_up[0]
      (1...m).each { |c| prefix_sum_up[c] = (prefix_sum_up[c - 1] + just_moved_up[c]) % mod }

      max_col_diff_horz = d

      (0...m).each do |c|
        next unless grid[r][c] == "."

        sum = 0
        # Left side
        c_start1 = [0, c - max_col_diff_horz].max
        c_end1 = c - 1
        if c_end1 >= c_start1
          term = prefix_sum_up[c_end1]
          term -= prefix_sum_up[c_start1 - 1] if c_start1 > 0
          sum = (sum + term + mod) % mod
        end

        # Right side
        c_start2 = c + 1
        c_end2 = [m - 1, c + max_col_diff_horz].min
        if c_end2 >= c_start2
          term = prefix_sum_up[c_end2]
          term -= prefix_sum_up[c_start2 - 1] if c_start2 > 0
          sum = (sum + term + mod) % mod
        end
        dp[r][c][1] = sum
      end
    end
    # rubocop: enable Metrics/BlockLength

    # Final result
    total_routes = 0
    (0...m).each do |c|
      total_routes = (total_routes + dp[0][c][0] + dp[0][c][1]) % mod
    end

    total_routes
  end
end
