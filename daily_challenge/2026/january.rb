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
end
