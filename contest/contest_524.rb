class Contest524
  # Minimum Deletions to Make Array Sharp
  # @param {Integer[]} nums
  # @return {Integer}
  def min_deletions(nums)
    deletions = 0
    prev = nil
    nums.each do |n|
      if n == prev
        deletions += 1   # same as the last kept element → must delete
      else
        prev = n         # keep it, becomes the new neighbor
      end
    end
    deletions
  end

  # Last Visited Cell in a Directional Grid
  # @param {Character[][]} grid
  # @return {Integer[]}
  def last_visited_cell(grid)
    m = grid.length
    n = grid[0].length
    visited = Array.new(m) { Array.new(n, false) }

    moves = { "L" => [0, -1], "R" => [0, 1], "U" => [-1, 0], "D" => [1, 0] }

    r = 0
    c = 0
    visited[0][0] = true

    loop do
      dr, dc = moves[grid[r][c]]
      nr = r + dr
      nc = c + dc

      # Stop if the move leaves the grid or enters a visited cell.
      break if nr < 0 || nr >= m || nc < 0 || nc >= n || visited[nr][nc]

      r = nr
      c = nc
      visited[r][c] = true
    end

    [r, c]
  end
end
