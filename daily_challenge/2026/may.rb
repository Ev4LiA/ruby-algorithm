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
    end
    (0...n).each do |i|
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
end
