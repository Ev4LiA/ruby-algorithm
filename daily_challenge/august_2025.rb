class August2025
  # 118. Pascal's Triangle
  # @param {Integer} num_rows
  # @return {Integer[][]}
  def generate(num_rows)
    return [[1]] if num_rows == 1
    return [[1], [1, 1]] if num_rows == 2

    res = [[1], [1, 1]]
    (3..num_rows).each do |i|
      prev_row = res[i - 2]
      row = [1]
      (0...prev_row.size - 1).each do |j|
        row << (prev_row[j] + prev_row[j + 1])
      end
      row << 1
      res << row
    end
    res
  end

  # 2561. Rearranging Fruits
  # @param {Integer[]} basket1
  # @param {Integer[]} basket2
  # @return {Integer}
  def min_cost(basket1, basket2)
    freq = basket1.tally
    basket2.each do |fruit|
      freq[fruit] ||= 0
      freq[fruit] -= 1
    end

    min_element = [basket1.min, basket2.min].min

    merge = []
    freq.each do |fruit, count|
      return -1 if count.odd?

      (0...count.abs / 2).each do |_|
        merge << fruit
      end
    end

    merge.sort!
    res = 0
    (0...merge.size / 2).each do |i|
      res += [merge[i], 2 * min_element].min
    end
    res
  end

  # 2106. Maximum Fruits Harvested After at Most K Steps
  # @param {Integer[][]} fruits
  # @param {Integer} start_pos
  # @param {Integer} k
  # @return {Integer}
  def max_total_fruits(fruits, start_pos, k)
    n = fruits.size
    sum = Array.new(n + 1, 0)
    indices = Array.new(n)
    sum[0] = 0
    (0...n).each do |i|
      sum[i + 1] = sum[i] + fruits[i][1]
      indices[i] = fruits[i][0]
    end
    ans = 0
    (0..k / 2).each do |x|
      y = k - (2 * x)
      left = start_pos - x
      right = start_pos + y
      start = lower_bound(indices, 0, n - 1, left)
      end_1 = upper_bound(indices, 0, n - 1, right)
      ans = [ans, sum[end_1] - sum[start]].max

      y = k - (2 * x)
      left = start_pos - y
      right = start_pos + x
      start = lower_bound(indices, 0, n - 1, left)
      end_2 = upper_bound(indices, 0, n - 1, right)
      ans = [ans, sum[end_2] - sum[start]].max
    end
    ans
  end

  def lower_bound(arr, left, right, val)
    res = right + 1
    while left <= right
      mid = left + ((right - left) / 2)
      if arr[mid] < val
        left = mid + 1
      else
        res = mid
        right = mid - 1
      end
    end
    res
  end

  def upper_bound(arr, left, right, val)
    res = right + 1
    while left <= right
      mid = left + ((right - left) / 2)
      if arr[mid] <= val
        left = mid + 1
      else
        res = mid
        right = mid - 1
      end
    end
    res
  end
  su
  # Second methods (using sliding window)
  def max_total_fruits_sliding_window(fruits, start_pos, k)
    left = 0
    right = 0
    n = fruits.length
    sum = 0
    ans = 0
    step = lambda do |fruits, start_pos, left, right|
      [(start_pos - fruits[right][0]).abs, (start_pos - fruits[left][0]).abs].min + fruits[right][0] - fruits[left][0]
    end

    while right < n
      sum += fruits[right][1]

      while left <= right && step.call(fruits, start_pos, left, right) > k
        sum -= fruits[left][1]
        left += 1
      end

      ans = [ans, sum].max
      right += 1
    end
    ans
  end

  # 3477. Fruits Into Baskets II
  # @param {Integer[]} fruits
  # @param {Integer[]} baskets
  # @return {Integer}
  def num_of_unplaced_fruits(fruits, baskets)
    count = 0
    n = baskets.size

    fruits.each do |fruit|
      placed = false
      (0...n).each do |i|
        next unless baskets[i] >= fruit

        baskets[i] = 0
        placed = true
        break
      end
      count += 1 unless placed
    end
    count
  end

  # 3479. Fruits Into Baskets III
  # @param {Integer[]} fruits
  # @param {Integer[]} baskets
  # @return {Integer}
  def num_of_unplaced_fruits_iii(fruits, baskets)
    n = baskets.size
    m = Math.sqrt(n).to_i

    sections = (n + m - 1) / m
    count = 0

    max_v = Array.new(sections) { 0 }

    (0...n).each { |i| max_v[i / m] = [max_v[i / m], baskets[i]].max }

    fruits.each do |fruit|
      un_set = true
      (0...sections).each do |section|
        next if max_v[section] < fruit

        choose = false
        max_v[section] = 0
        (0...m).each do |j|
          pos = (section * m) + j
          if pos < n && baskets[pos] >= fruit && !choose
            baskets[pos] = 0
            choose = true
          end

          max_v[section] = [max_v[section], baskets[pos]].max if pos < n
        end

        un_set = false
        break
      end
      count += 1 if un_set
    end

    count
  end

  # 3363. Find the Maximum Number of Fruits Collected
  # @param {Integer[][]} fruits
  # @return {Integer}
  def max_collected_fruits(fruits)
    n = fruits.length
    ans = 0
    (0...n).each { |i| ans += fruits[i][i] }

    infinity_neg = -Float::INFINITY

    dp = lambda do
      prev = Array.new(n, infinity_neg)
      curr = Array.new(n, infinity_neg)
      prev[n - 1] = fruits[0][n - 1]

      (1...(n - 1)).each do |i|
        start_j = [n - 1 - i, i + 1].max
        (start_j...n).each do |j|
          best = prev[j]
          best = [best, prev[j - 1]].max if j - 1 >= 0
          best = [best, prev[j + 1]].max if j + 1 < n
          curr[j] = best + fruits[i][j]
        end
        prev = curr
        curr = Array.new(n, infinity_neg)
      end

      prev[n - 1]
    end

    ans += dp.call

    # Transpose matrix in-place (upper triangle to lower)
    (0...n).each do |i|
      (0...i).each do |j|
        fruits[i][j], fruits[j][i] = fruits[j][i], fruits[i][j]
      end
    end

    ans += dp.call
    ans
  end

  # 808. Soup Servings
  # @param {Integer} n
  # @return {Float}
  def soup_servings(n)
    # For very large n, probability approaches 1
    return 1.0 if n > 4800

    m = (n.to_f / 25).ceil
    dp = Hash.new { |h, k| h[k] = {} }

    calculate_dp = nil
    calculate_dp = lambda do |i, j|
      return 0.5 if i <= 0 && j <= 0
      return 1.0 if i <= 0
      return 0.0 if j <= 0
      return dp[i][j] if dp[i].key?(j)

      res = (
        calculate_dp.call(i - 4, j) +
        calculate_dp.call(i - 3, j - 1) +
        calculate_dp.call(i - 2, j - 2) +
        calculate_dp.call(i - 1, j - 3)
      ) / 4.0
      dp[i][j] = res
      res
    end

    (1..m).each do |k|
      return 1.0 if calculate_dp.call(k, k) > 1 - 1e-5
    end

    calculate_dp.call(m, m)
  end

  # 231. Power of Two
  # @param {Integer} n
  # @return {Boolean}
  def is_power_of_two(n)
    return false if n <= 0

    (n & (n - 1)).zero?
  end

  # 869. Reordered Power of 2
  # @param {Integer} n
  # @return {Boolean}
  def reordered_power_of2(n)
    n_str = n.to_s.chars.sort.join
    31.times do |i|
      power_of_2 = 2**i
      power_of_2_str = power_of_2.to_s.chars.sort.join
      return true if power_of_2_str == n_str
    end
    false
  end

  # 2438. Range Product Queries of Powers
  # @param {Integer} n
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def product_queries(n, queries)
    bins = []
    rep = 1

    while n > 0
      bins << rep if n.odd?
      n /= 2
      rep *= 2
    end

    res = []
    queries.each do |query|
      left, right = query
      res << (bins[left..right].reduce(:*) % ((10**9) + 7))
    end
    res
  end

  # 2787. Ways to Express an Integer as Sum of Powers
  # @param {Integer} n
  # @param {Integer} x
  # @return {Integer}
  def number_of_ways(n, x)
    dp = Array.new(n + 1, 0)
    dp[0] = 1

    (1..n).each do |i|
      val = i**x
      break if val > n

      (val..n).reverse_each do |j|
        dp[j] = (dp[j] + dp[j - val]) % ((10**9) + 7)
      end
    end

    dp[n]
  end

  # 326. Power of Three
  # @param {Integer} n
  # @return {Boolean}
  def is_power_of_three(n)
    return false if n <= 0

    n /= 3 while (n % 3).zero?

    n == 1
  end

  # 2264. Largest 3-Same-Digit Number in String
  # @param {String} num
  # @return {String}
  def largest_good_integer(num)
    max_digit = -1
    (0..num.length - 3).each do |i|
      max_digit = [max_digit, num[i].to_i].max if num[i] == num[i + 1] && num[i] == num[i + 2]
    end
    max_digit.negative? ? "" : max_digit.to_s * 3
  end

  # 342. Power of Four
  # @param {Integer} n
  # @return {Boolean}
  def is_power_of_four(n)
    return false if n <= 0

    n /= 4 while (n % 4).zero?
    n == 1
  end

  # 1323. Maximum 69 Number
  # @param {Integer} num
  # @return {Integer}
  def maximum69_number(num)
    num.to_s.sub("6", "9").to_i
  end

  # 837. New 21 Game
  # @param {Integer} n
  # @param {Integer} k
  # @param {Integer} max_pts
  # @return {Float}
  def new21_game(n, k, max_pts)
    return 1.0 if k == 0 || n >= k + max_pts

    dp = Array.new(n + 1, 0.0)
    dp[0] = 1.0
    window_sum = 1.0 # sum of last max_pts dp values that are < k
    result = 0.0

    (1..n).each do |i|
      dp[i] = window_sum / max_pts

      if i < k
        window_sum += dp[i]
      else
        result += dp[i]
      end

      window_sum -= dp[i - max_pts] if i - max_pts >= 0
    end

    result
  end

  # 679. 24 Game
  # @param {Integer[]} cards
  # @return {Boolean}
  def judge_point24(cards)
    nums = cards.map(&:to_f)
    eps = 1e-6

    dfs = nil
    dfs = lambda do |arr|
      return ((arr[0] - 24.0).abs < eps) if arr.size == 1

      arr.each_index do |i|
        arr.each_index do |j|
          next if i == j

          next_arr = []
          arr.each_index { |k| next_arr << arr[k] if k != i && k != j }

          a = arr[i]
          b = arr[j]

          [a + b, a - b, b - a, a * b].each do |val|
            next_arr.push(val)
            return true if dfs.call(next_arr)

            next_arr.pop
          end

          unless b.abs < eps
            next_arr.push(a / b)
            return true if dfs.call(next_arr)

            next_arr.pop
          end

          next if a.abs < eps

          next_arr.push(b / a)
          return true if dfs.call(next_arr)

          next_arr.pop
        end
      end
      false
    end

    dfs.call(nums)
  end

  # 2348. Number of Zero-Filled Subarrays
  # @param {Integer[]} nums
  # @return {Integer}
  def zero_filled_subarray(nums)
    res = 0
    count = 0

    nums.each do |num|
      if num.zero?
        count += 1
        res += count
      else
        count = 0
      end
    end
    res
  end

  # 1277. Count Square Submatrices with All Ones
  # @param {Integer[][]} matrix
  # @return {Integer}
  def count_squares(matrix)
    row = matrix.size
    col = matrix[0].size
    dp = Array.new(row + 1) { Array.new(col + 1, 0) }
    res = 0

    (0...row).each do |i|
      (0...col).each do |j|
        if matrix[i][j] == 1
          dp[i + 1][j + 1] = [dp[i][j], dp[i + 1][j], dp[i][j + 1]].min + 1
          res += dp[i + 1][j + 1]
        end
      end
    end
    res
  end

  # 1504. Count Submatrices With All Ones
  # @param {Integer[][]} mat
  # @return {Integer}
  def num_submat(mat)
    row = mat.size
    col = mat[0].size
    res = 0
    rows = Array.new(row) { Array.new(col, 0) }

    (0...row).each do |i|
      (0...col).each do |j|
        rows[i][j] = if j.zero?
                       mat[i][j]
                     else
                       mat[i][j].zero? ? 0 : rows[i][j - 1] + 1
                     end

        cur = rows[i][j]
        i.downto(0) do |k|
          cur = [cur, rows[k][j]].min
          break if cur.zero?

          res += cur
        end
      end
    end
    res
  end

  # 3195. Find the Minimum Area to Cover All Ones I
  # @param {Integer[][]} grid
  # @return {Integer}
  def minimum_area(grid)
    row = grid.size
    col = grid[0].size
    min_row = row
    max_row = 0
    min_col = col
    max_col = 0

    (0...row).each do |i|
      (0...col).each do |j|
        next if grid[i][j].zero?

        min_row = [min_row, i].min
        max_row = [max_row, i].max
        min_col = [min_col, j].min
        max_col = [max_col, j].max
      end
    end
    (max_row - min_row + 1) * (max_col - min_col + 1)
  end

  # 3197. Find the Minimum Area to Cover All Ones II
  # @param {Integer[][]} grid
  # @return {Integer}
  def minimum_sum(grid)
    n = grid.size
    m = grid[0].size

    min_sum2 = lambda do |g, u, d, l, r|
      min_i = n
      max_i = -1
      min_j = m
      max_j = -1

      (u..d).each do |i|
        (l..r).each do |j|
          next if g[i][j].zero?

          min_i = [min_i, i].min
          max_i = [max_i, i].max
          min_j = [min_j, j].min
          max_j = [max_j, j].max
        end
      end

      min_i <= max_i ? (max_i - min_i + 1) * (max_j - min_j + 1) : Float::INFINITY / 3
    end

    rotate = lambda do |vec|
      r = vec.size
      c = vec[0].size
      ret = Array.new(c) { Array.new(r, 0) }
      (0...r).each do |i|
        (0...c).each do |j|
          ret[c - j - 1][i] = vec[i][j]
        end
      end
      ret
    end

    solve = lambda do |g|
      n = g.size
      m = g[0].size
      res = n * m

      # partition into three rectangles with a horizontal cut and a vertical cut below it
      (0...n - 1).each do |i|
        (0...m - 1).each do |j|
          res = [res,
                 min_sum2.call(g, 0, i, 0, m - 1) +
                   min_sum2.call(g, i + 1, n - 1, 0, j) +
                   min_sum2.call(g, i + 1, n - 1, j + 1, m - 1)].min

          res = [res,
                 min_sum2.call(g, 0, i, 0, j) +
                   min_sum2.call(g, 0, i, j + 1, m - 1) +
                   min_sum2.call(g, i + 1, n - 1, 0, m - 1)].min
        end
      end

      # partition into three horizontal stripes
      (0...n - 2).each do |i|
        ((i + 1)...n - 1).each do |j|
          res = [res,
                 min_sum2.call(g, 0, i, 0, m - 1) +
                   min_sum2.call(g, i + 1, j, 0, m - 1) +
                   min_sum2.call(g, j + 1, n - 1, 0, m - 1)].min
        end
      end

      res
    end

    rgrid = rotate.call(grid)
    [solve.call(grid), solve.call(rgrid)].min
  end

  # 1493. Longest Subarray of 1's After Deleting One Element
  # @param {Integer[]} nums
  # @return {Integer}
  def longest_subarray(nums)
    start = 0
    zero_count = 0
    res = 0
    nums.each_with_index do |num, i|
      zero_count += num.zero? ? 1 : 0

      while zero_count > 1
        zero_count -= nums[start].zero? ? 1 : 0
        start += 1
      end
      res = [res, i - start].max
    end
    res
  end

  # 498. Diagonal Traverse
  # @param {Integer[][]} mat
  # @return {Integer[]}
  def find_diagonal_order(mat)
    return [] if mat.empty? || mat[0].empty?

    n = mat.length
    m = mat[0].length

    row = 0
    col = 0
    direction = 1 # 1 => up-right, 0 => down-left (same as Java's flip with 1-direction)

    result = Array.new(n * m)
    idx = 0

    while row < n && col < m
      result[idx] = mat[row][col]
      idx += 1

      new_row = row + (direction == 1 ? -1 : 1)
      new_col = col + (direction == 1 ? 1 : -1)

      # If out of bounds, move to next head and flip direction
      if new_row.negative? || new_row == n || new_col.negative? || new_col == m
        if direction == 1
          # moving up-right, prefer moving right if possible else move down
          if col == m - 1
            row += 1
          else
            col += 1
          end
        elsif row == n - 1
          # moving down-left, prefer moving down if possible else move right
          col += 1
        else
          row += 1
        end
        direction = 1 - direction
      else
        row = new_row
        col = new_col
      end
    end

    result
  end

  # 3000. Maximum Area of Longest Diagonal Rectangle
  # @param {Integer[][]} dimensions
  # @return {Integer}
  def area_of_max_diagonal(dimensions)
    max_diagonal = 0
    max_area = 0

    dimensions.each do |dimension|
      if (dimension[0]**2) + (dimension[1]**2) > max_diagonal
        max_diagonal = (dimension[0]**2) + (dimension[1]**2)
        max_area = dimension[0] * dimension[1]
      elsif (dimension[0]**2) + (dimension[1]**2) == max_diagonal
        max_area = [max_area, dimension[0] * dimension[1]].max
      end
    end
    max_area
  end

  # @param {Integer[][]} grid
  # @return {Integer}
  def len_of_v_diagonal(grid)
    # Return 0 for empty input
    return 0 if grid.empty? || grid[0].empty?

    m = grid.length
    n = grid[0].length

    # Four diagonal directions in clockwise order:
    # 0: down-right  ( +1, +1 )
    # 1: down-left   ( +1, −1 )
    # 2: up-left     ( −1, −1 )
    # 3: up-right    ( −1, +1 )
    dirs = [[1, 1], [1, -1], [-1, -1], [-1, 1]].freeze

    # memo[x][y][dir][turn] stores the longest length starting **after** (x, y)
    # when moving in "dir" with `turn` indicating whether the 90° turn is still allowed.
    # We lazily allocate to keep memory reasonable.
    memo = Array.new(m) { Array.new(n) { Array.new(4) { Array.new(2, -1) } } }

    # Recursive DFS with memoisation.
    dfs = lambda do |cx, cy, direction, turn_left, target|
      nx = cx + dirs[direction][0]
      ny = cy + dirs[direction][1]

      # Stop if out of bounds or the next value does not match the expected target.
      return 0 if nx.negative? || ny.negative? || nx >= m || ny >= n || grid[nx][ny] != target

      turn_idx = turn_left ? 1 : 0
      cached = memo[nx][ny][direction][turn_idx]
      return cached if cached != -1

      # Continue in the same direction; the next expected value alternates between 2 and 0.
      next_target = 2 - target
      max_step = dfs.call(nx, ny, direction, turn_left, next_target)

      # If the 90-degree turn is still available, try turning clockwise once.
      if turn_left
        turned_dir = (direction + 1) % 4
        max_step = [max_step, dfs.call(nx, ny, turned_dir, false, next_target)].max
      end

      memo[nx][ny][direction][turn_idx] = max_step + 1
      max_step + 1
    end

    res = 0

    (0...m).each do |i|
      (0...n).each do |j|
        next unless grid[i][j] == 1

        4.times do |dir|
          res = [res, dfs.call(i, j, dir, true, 2) + 1].max
        end
      end
    end

    res
  end

  # 3446. Sort Matrix by Diagonals
  # Given an n x n matrix `grid`, sort each diagonal that starts on:
  #   • the left border (row i, col 0) in DESCENDING order, then
  #   • the top border (row 0, col j) – except j = 0 – in ASCENDING order.
  # Returns the modified matrix.
  # @param [Integer[][]] grid
  # @return [Integer[][]]
  def sort_matrix(grid)
    n = grid.size

    # 1) diagonals starting from first column (descending sort)
    (0...n).each do |row_start|
      diag = []
      col = 0
      row = row_start
      while row < n && col < n
        diag << grid[row][col]
        row += 1
        col += 1
      end

      diag.sort!.reverse! # descending order

      # write back
      row = row_start
      col = 0
      idx = 0
      while row < n && col < n
        grid[row][col] = diag[idx]
        row += 1
        col += 1
        idx += 1
      end
    end

    # 2) diagonals starting from top row (ascending sort), skip first cell
    (1...n).each do |col_start|
      diag = []
      row = 0
      col = col_start
      while row < n && col < n
        diag << grid[row][col]
        row += 1
        col += 1
      end

      diag.sort! # ascending order

      # write back
      row = 0
      col = col_start
      idx = 0
      while row < n && col < n
        grid[row][col] = diag[idx]
        row += 1
        col += 1
        idx += 1
      end
    end

    grid
  end

  # 3021. Alice and Bob Playing Flower Game
  # @param {Integer} n
  # @param {Integer} m
  # @return {Integer}
  def flower_game(n, m)
    (m * n) / 2
  end

  # 36. Valid Sudoku
  # @param {Character[][]} board
  # @return {Boolean}
  def is_valid_sudoku(board)
    rows = Array.new(9) { Array.new(9, 0) }
    cols = Array.new(9) { Array.new(9, 0) }
    boxes = Array.new(9) { Array.new(9, 0) }

    9.times do |i|
      9.times do |j|
        next if board[i][j] == "."

        num = board[i][j].to_i - 1
        rows[i][num] += 1
        cols[j][num] += 1
        boxes[(i / 3 * 3) + (j / 3)][num] += 1

        return false if rows[i][num] > 1 || cols[j][num] > 1 || boxes[(i / 3 * 3) + (j / 3)][num] > 1
      end
    end
    true
  end

  # 37. Sudoku Solver
  # @param {Character[][]} board
  # @return {Void} Do not return anything, modify board in-place instead.
  def solve_sudoku(board)
    rows = Array.new(9) { Array.new(9, 0) }
    cols = Array.new(9) { Array.new(9, 0) }
    boxes = Array.new(9) { Array.new(9, 0) }

    solved = false

    backtrack = nil

    place_number = lambda do |num, row, col|
      idx = ((row / 3) * 3) + (col / 3)
      rows[row][num - 1] += 1
      cols[col][num - 1] += 1
      boxes[idx][num - 1] += 1
      board[row][col] = num.to_s
    end

    could_place = lambda do |num, row, col|
      idx = ((row / 3) * 3) + (col / 3)
      rows[row][num - 1].zero? && cols[col][num - 1].zero? && boxes[idx][num - 1].zero?
    end

    remove_number = lambda do |num, row, col|
      idx = ((row / 3) * 3) + (col / 3)
      rows[row][num - 1] -= 1
      cols[col][num - 1] -= 1
      boxes[idx][num - 1] -= 1
      board[row][col] = "."
    end

    place_next_numbers = lambda do |row, col|
      if row == 8 && col == 8
        solved = true
      elsif col == 8
        backtrack.call(row + 1, 0)
      else
        backtrack.call(row, col + 1)
      end
    end

    backtrack = lambda do |row, col|
      if board[row][col] == "."
        (1..9).each do |num|
          next unless could_place.call(num, row, col)

          place_number.call(num, row, col)
          place_next_numbers.call(row, col)
          remove_number.call(num, row, col) unless solved
        end
      else
        place_next_numbers.call(row, col)
      end
    end

    9.times do |i|
      9.times do |j|
        place_number.call(board[i][j].to_i, i, j) if board[i][j] != "."
      end
    end

    backtrack.call(0, 0)
  end
end
