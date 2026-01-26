class January2026
  # 66. Plus One
  # @param {Integer[]} digits
  # @return {Integer[]}
  def plus_one(digits)
    n = digits.length
    (n - 1).downto(0) do |i|
      if digits[i] < 9
        digits[i] += 1
        return digits
      end
      digits[i] = 0
    end
    [1] + digits
  end

  # 961. N-Repeated Element in Size 2N Array
  # @param {Integer[]} nums
  # @return {Integer}
  def repeated_n_times(nums)
    hash = Hash.new(0)

    nums.each do |n|
      hash[n] += 1
      return n if hash[n] == 2
    end
  end

  # 1411. Number of Ways to Paint N × 3 Grid
  # @param {Integer} n
  # @return {Integer}
  def num_of_ways(n)
    mod = (10**9) + 7
    a = 6
    b = 6
    (2..n).each do |_i|
      new_a = ((2 * a) + (2 * b)) % mod
      new_b = ((2 * a) + (3 * b)) % mod
      a = new_a
      b = new_b
    end

    (a + b) % mod
  end

  # 1390. Four Divisors
  # @param {Integer[]} nums
  # @return {Integer}
  def sum_four_divisors(nums)
    sum = 0
    nums.each do |num|
      divisors = []
      (1..Math.sqrt(num)).each do |i|
        if (num % i).zero?
          divisors << i
          divisors << (num / i) if i != num / i
        end
      end
      sum += divisors.sum if divisors.length == 4
    end

    sum
  end

  # 1975. Maximum Matrix Sum
  # @param {Integer[][]} matrix
  # @return {Integer}
  def max_matrix_sum(matrix)
    total_sum = 0
    min_abs_val = Float::INFINITY
    negative_count = 0

    matrix.each do |row|
      row.each do |val|
        total_sum += val.abs
        negative_count += 1 if val < 0
        min_abs_val = [min_abs_val, val.abs].min
      end
    end

    total_sum -= 2 * min_abs_val if negative_count.odd?

    total_sum
  end

  # 1161. Maximum Level Sum of a Binary Tree
  # Definition for a binary tree node.
  # class TreeNode
  #     attr_accessor :val, :left, :right
  #     def initialize(val = 0, left = nil, right = nil)
  #         @val = val
  #         @left = left
  #         @right = right
  #     end
  # end
  # @param {TreeNode} root
  # @return {Integer}
  def max_level_sum(root)
    max_sum = -Float::INFINITY
    ans = 0
    level = 0
    queue = [root]
    until queue.empty?
      level += 1

      level_sum = 0
      level_size = queue.size
      level_size.times do
        node = queue.shift
        level_sum += node.val
        queue << node.left if node.left
        queue << node.right if node.right
      end
      if level_sum > max_sum
        max_sum = level_sum
        ans = level
      end
    end
    ans
  end

  # 85. Maximal Rectangle
  # @param {Character[][]} matrix
  # @return {Integer}
  def maximal_rectangle(matrix)
    return 0 if matrix.empty? || matrix[0].empty?

    m = matrix.size
    n = matrix[0].size
    max_area = 0
    hist = Array.new(n, 0)

    (0...m).each do |i|
      (0...n).each do |j|
        if matrix[i][j] == "1"
          hist[j] += 1
        else
          hist[j] = 0
        end
      end
      max_area = [max_area, area(hist)].max
    end
    max_area
  end

  def area(hist)
    n = hist.size
    max_area = 0
    stack = [] # Stores indices

    # Add a sentinel 0 at the end to ensure all bars in the stack are processed
    (0..n).each do |i|
      h = i == n ? 0 : hist[i]

      while !stack.empty? && h < hist[stack.last]
        height = hist[stack.pop]
        width = stack.empty? ? i : i - stack.last - 1
        max_area = [max_area, height * width].max
      end
      stack.push(i)
    end
    max_area
  end

  # 1266. Minimum Time Visiting All Points
  # @param {Integer[][]} points
  # @return {Integer}
  def min_time_to_visit_all_points(points)
    ans = 0
    (0...points.length - 1).each do |i|
      currX = points[i][0]
      currY = points[i][1]
      targetX = points[i + 1][0]
      targetY = points[i + 1][1]
      ans += [(targetX - currX).abs, (targetY - currY).abs].max
    end
    ans
  end

  # 3453. Separate Squares I
  # @param {Integer[][]} squares
  # @return {Float}
  def separate_squares(squares)
    max_y = 0.0
    total_area = 0.0

    squares.each do |sq|
      y = sq[1]
      l = sq[2]
      total_area += (l.to_f * l.to_f)
      max_y = [max_y, y.to_f + l.to_f].max
    end

    lo = 0.0
    hi = max_y
    eps = 1e-5

    while (hi - lo).abs > eps
      mid = (hi + lo) / 2.0
      if check(mid, squares, total_area)
        hi = mid
      else
        lo = mid
      end
    end

    hi
  end

  def check(limit_y, squares, total_area)
    area = 0.0
    squares.each do |sq|
      y = sq[1].to_f
      l = sq[2].to_f
      area += l * [limit_y - y, l].min if y < limit_y
    end
    area >= total_area / 2.0
  end

  # 3047. Find the Largest Area of Square Inside Two Rectangles
  # @param {Integer[][]} bottom_left
  # @param {Integer[][]} top_right
  # @return {Integer}
  def largest_square_area(bottom_left, top_right)
    n = bottom_left.length
    max_square_area = 0

    # Iterate through all unique pairs of rectangles
    (0...n).each do |i|
      (i + 1...n).each do |j|
        # Coordinates for rectangle i
        x1_i, y1_i = bottom_left[i]
        x2_i, y2_i = top_right[i]

        # Coordinates for rectangle j
        x1_j, y1_j = bottom_left[j]
        x2_j, y2_j = top_right[j]

        # Calculate the intersection rectangle's coordinates
        ix1 = [x1_i, x1_j].max
        iy1 = [y1_i, y1_j].max
        ix2 = [x2_i, x2_j].min
        iy2 = [y2_i, y2_j].min

        # Calculate width and height of the intersection
        width = ix2 - ix1
        height = iy2 - iy1

        # If there's a valid intersection with positive width and height
        next unless width > 0 && height > 0

        # The side length of the largest square is the minimum of the intersection's dimensions
        side = [width, height].min
        current_square_area = side * side
        max_square_area = [max_square_area, current_square_area].max
      end
    end

    max_square_area
  end

  # 1895. Largest Magic Square
  # @param {Integer[][]} grid
  # @return {Integer}
  def largest_magic_square(grid)
    m = grid.length
    n = grid[0].length

    row_prefix_sum = Array.new(m) { Array.new(n + 1, 0) }
    (0...m).each do |r|
      (0...n).each do |c|
        row_prefix_sum[r][c + 1] = row_prefix_sum[r][c] + grid[r][c]
      end
    end

    col_prefix_sum = Array.new(m + 1) { Array.new(n, 0) }
    (0...n).each do |c|
      (0...m).each do |r|
        col_prefix_sum[r + 1][c] = col_prefix_sum[r][c] + grid[r][c]
      end
    end

    [m, n].min.downto(2) do |k|
      (0..m - k).each do |r|
        (0..n - k).each do |c|
          diag1_sum = 0
          (0...k).each do |i|
            diag1_sum += grid[r + i][c + i]
          end

          diag2_sum = 0
          (0...k).each do |i|
            diag2_sum += grid[r + i][c + k - 1 - i]
          end

          next if diag1_sum != diag2_sum

          is_magic = true
          magic_sum = diag1_sum

          (0...k).each do |i|
            row_sum = row_prefix_sum[r + i][c + k] - row_prefix_sum[r + i][c]
            if row_sum != magic_sum
              is_magic = false
              break
            end
          end

          next unless is_magic

          (0...k).each do |i|
            col_sum = col_prefix_sum[r + k][c + i] - col_prefix_sum[r][c + i]
            if col_sum != magic_sum
              is_magic = false
              break
            end
          end

          return k if is_magic
        end
      end
    end

    1
  end

  # 1877. Minimize Maximum Pair Sum in Array
  # @param {Integer[]} nums
  # @return {Integer}
  def min_pair_sum(nums)
    nums.sort!
    max_sum = 0
    (0...nums.length / 2).each do |i|
      max_sum = [max_sum, nums[i] + nums[nums.length - i - 1]].max
    end
    max_sum
  end

  # 1984. Minimum Difference Between Highest and Lowest of K Scores
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def minimum_difference(nums, k)
    nums.sort!
    (0...nums.length - k + 1).map { |i| nums[i + k - 1] - nums[i] }.min
  end

  # 1200. Minimum Absolute Difference
  # @param {Integer[]} arr
  # @return {Integer[][]}
  def minimum_abs_difference(arr)
    arr.sort!
    min_diff = Float::INFINITY
    pairs = []
    (0...arr.length - 1).each do |i|
      diff = arr[i + 1] - arr[i]
      if diff < min_diff
        min_diff = diff
        pairs = [[arr[i], arr[i + 1]]]
      elsif diff == min_diff
        pairs << [arr[i], arr[i + 1]]
      end
    end
    pairs
  end
end
