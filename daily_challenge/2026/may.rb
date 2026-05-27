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

  # 48. Rotate Image
  # @param {Integer[][]} matrix
  # @return {Void} Do not return anything, modify matrix in-place instead.
  def rotate(matrix)
    n = matrix.length
    (0...n).each do |i|
      (i...n).each do |j|
        matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
      end
      (0...n / 2).each do |j|
        matrix[i][j], matrix[i][n - 1 - j] = matrix[i][n - 1 - j], matrix[i][j]
      end
    end
  end

  # 1914. Cyclically Rotating a Grid
  # @param {Integer[][]} grid
  # @param {Integer} k
  # @return {Integer[][]}
  def rotate_grid(grid, k)
    m = grid.length
    n = grid[0].length
    nlayer = [m, n].min / 2 # level count
    # enumerate each layer counterclockwise starting from the top-left corner
    (0...nlayer).each do |layer|
      r = []
      c = []
      val = [] # each element's row index, column index, and value
      (layer...m - layer - 1).each do |i| # left
        r << i
        c << layer
        val << grid[i][layer]
      end
      (layer...n - layer - 1).each do |j| # down
        r << (m - layer - 1)
        c << j
        val << grid[m - layer - 1][j]
      end
      (m - layer - 1).downto(layer + 1) do |i| # right
        r << i
        c << (n - layer - 1)
        val << grid[i][n - layer - 1]
      end
      (n - layer - 1).downto(layer + 1) do |j| # up
        r << layer
        c << j
        val << grid[layer][j]
      end
      total = val.size # total number of elements in each layer
      kk = k % total # equivalent number of rotations
      # find the value at each index after rotation
      (0...total).each do |i|
        idx = (i + total - kk) % total # the index corresponding to the value after rotation
        grid[r[i]][c[i]] = val[idx]
      end
    end
    grid
  end

  # 2770. Maximum Number of Jumps to Reach the Last Index
  # @param {Integer[]} nums
  # @param {Integer} target
  # @return {Integer}
  def maximum_jumps(nums, target)
    n = nums.length
    # dp[i] = max jumps to reach i (or -1 if unreachable)
    dp = Array.new(n, -1)
    dp[0] = 0

    (1...n).each do |j|
      (0...j).each do |i|
        next if dp[i] == -1

        diff = nums[j] - nums[i]
        dp[j] = [dp[j], dp[i] + 1].max if -target <= diff && diff <= target
      end
    end

    dp[n - 1]
  end

  # 1306. Jump Game III
  # @param {Integer[]} arr
  # @param {Integer} start
  # @return {Boolean}
  def can_reach(arr, start)
    n = arr.length
    visited = Array.new(n, false)
    queue = [start]
    visited[start] = true

    until queue.empty?
      i = queue.shift

      # If we reach a value 0, we're done
      return true if (arr[i]).zero?

      # Next positions we can jump to
      [i + arr[i], i - arr[i]].each do |next_i|
        # Stay in bounds and avoid revisiting
        if next_i >= 0 && next_i < n && !visited[next_i]
          visited[next_i] = true
          queue << next_i
        end
      end
    end

    false
  end

  # 2540. Minimum Common Value
  # @param {Integer[]} nums1
  # @param {Integer[]} nums2
  # @return {Integer}
  def get_common(nums1, nums2)
    nums1_set = nums1.to_set
    nums2.each do |num|
      return num if nums1_set.include?(num)
    end
    -1
  end

  # 1752. Check if Array Is Sorted and Rotated
  # @param {Integer[]} nums
  # @return {Boolean}
  def check(nums)
    n = nums.length
    count = 0
    (0...n).each do |i|
      if nums[i] > nums[(i + 1) % n]
        count += 1
        return false if count > 1
      end
    end
    true
  end

  # 1340. Jump Game V
  # @param {Integer[]} arr
  # @param {Integer} d
  # @return {Integer}
  def max_jumps(arr, d)
    n = arr.length
    memo = Array.new(n, nil)

    dfs = lambda do |i|
      return memo[i] if memo[i]

      best = 1 # at least this index itself

      # explore left
      step = 1
      while step <= d && i - step >= 0
        j = i - step
        break if arr[j] >= arr[i] # must be strictly smaller, and can't jump "over" >=

        best = [best, 1 + dfs.call(j)].max
        step += 1
      end

      # explore right
      step = 1
      while step <= d && i + step < n
        j = i + step
        break if arr[j] >= arr[i]

        best = [best, 1 + dfs.call(j)].max
        step += 1
      end

      memo[i] = best
    end

    ans = 1
    (0...n).each do |i|
      ans = [ans, dfs.call(i)].max
    end
    ans
  end

  # 1871. Jump Game VII
  # @param {String} s
  # @param {Integer} min_jump
  # @param {Integer} max_jump
  # @return {Boolean}
  def can_reach(s, min_jump, max_jump)
    n = s.length
    return false if s[0] != "0" || s[n - 1] != "0"

    # dp[i] = true if index i is reachable
    dp = Array.new(n, false)
    dp[0] = true

    # prefix = number of reachable indices in the current window
    prefix = 0

    (1...n).each do |i|
      # when the window starts including i - min_jump
      start_idx = i - min_jump
      prefix += 1 if start_idx >= 0 && dp[start_idx]

      # when the window stops including i - max_jump - 1
      end_exclusive_idx = i - max_jump - 1
      prefix -= 1 if end_exclusive_idx >= 0 && dp[end_exclusive_idx]

      # i is reachable if:
      # 1) s[i] is '0'
      # 2) there is at least one reachable index in [i - max_jump, i - min_jump]
      dp[i] = (s[i] == "0" && prefix.positive?)
    end

    dp[n - 1]
  end

  # 3120. Count the Number of Special Characters I
  # @param {String} word
  # @return {Integer}
  def number_of_special_chars(word)
    lowers = Set.new
    uppers = Set.new

    word.each_char do |ch|
      if ch >= "a" && ch <= "z"
        lowers << ch
      else
        # only other valid chars by constraint are 'A'..'Z'
        uppers << ch
      end
    end

    # Count letters that appear in both lowercase and uppercase
    count = 0
    ("a".."z").each do |c|
      count += 1 if lowers.include?(c) && uppers.include?(c.upcase)
    end

    count
  end

  # 3121. Count the Number of Special Characters II
  # @param {String} word
  # @return {Integer}
  def number_of_special_chars(word)
    # For each letter 'a'..'z' (0..25):
    # lower[i] = last index of lowercase (i.e., 'a' + i), or -1 if never seen
    # upper[i] = first index of uppercase (i.e., 'A' + i), or -1 if never seen
    lower = Array.new(26, -1)
    upper = Array.new(26, -1)

    word.chars.each_with_index do |ch, i|
      if ch >= "a" && ch <= "z"
        idx = ch.ord - "a".ord
        lower[idx] = i # track *last* lowercase occurrence
      else
        idx = ch.ord - "A".ord
        upper[idx] = i if upper[idx] == -1 # track *first* uppercase occurrence
      end
    end

    # A letter c is special if:
    # - it appears in both lowercase and uppercase
    # - last lowercase index < first uppercase index
    count = 0
    26.times do |i|
      count += 1 if lower[i] != -1 && upper[i] != -1 && lower[i] < upper[i]
    end

    count
  end
end
