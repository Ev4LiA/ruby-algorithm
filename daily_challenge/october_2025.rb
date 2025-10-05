class October2025
  # 1518. Water Bottles
  # @param {Integer} num_bottles
  # @param {Integer} num_exchange
  # @return {Integer}
  def num_water_bottles(num_bottles, num_exchange)
    res = num_bottles
    while num_bottles >= num_exchange
      res += num_bottles / num_exchange
      num_bottles = (num_bottles / num_exchange) + (num_bottles % num_exchange)
    end
    res
  end

  # 3100. Water Bottles II
  # @param {Integer} num_bottles
  # @param {Integer} num_exchange
  # @return {Integer}
  def max_bottles_drunk(num_bottles, num_exchange)
    res = num_bottles
    while num_bottles >= num_exchange
      res += 1
      num_bottles = num_bottles - num_exchange + 1
      num_exchange += 1
    end
    res
  end

  # 11. Container With Most Water
  # @param {Integer[]} height
  # @return {Integer}
  def max_area(height)
    l = 0
    r = height.length - 1
    max_area = 0
    while l < r
      max_area = [max_area, (r - l) * [height[l], height[r]].min].max
      if height[l] < height[r]
        l += 1
      else
        r -= 1
      end
    end
    max_area
  end

  # 417. Pacific Atlantic Water Flow
  # @param {Integer[][]} heights
  # @return {Integer[][]}
  def pacific_atlantic(heights)
    rows = heights.length
    cols = heights[0].length
    pacific_visited = []
    atlantic_visited = []
    pacific_queue = []
    atlantic_queue = []

    (0...rows).each do |row|
      (0...cols).each do |col|
        # Pacific Ocean (top and left edge)
        if row.zero? || col.zero?
          pacific_visited << [row, col]
          pacific_queue << [row, col]
        end

        # Atlatic Ocean (bottom and right edge)
        if row == rows - 1 || col == cols - 1
          atlantic_visited << [row, col]
          atlantic_queue << [row, col]
        end
      end
    end

    bfs = lambda do |queue, visited|
      until queue.empty?
        row, col = queue.shift
        directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
        directions.each do |dr, dc|
          new_row = row + dr
          new_col = col + dc
          next if new_row.negative? || new_row >= rows || new_col.negative? || new_col >= cols
          next if heights[new_row][new_col] < heights[row][col]
          next if visited.include?([new_row, new_col])

          visited << [new_row, new_col]
          queue << [new_row, new_col]
        end
      end
    end

    bfs.call(pacific_queue, pacific_visited)
    bfs.call(atlantic_queue, atlantic_visited)

    pacific_visited & atlantic_visited
  end
end
