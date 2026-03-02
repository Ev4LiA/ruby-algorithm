class March2026
  # 1536. Minimum Swaps to Arrange a Binary Grid
  # @param {Integer[][]} grid
  # @return {Integer}
  def min_swaps(grid)
    n = grid.length
    trailing_zeros = Array.new(n, 0)

    (0...n).each do |i|
      count = 0
      (n - 1).downto(0) do |j|
        if grid[i][j] == 0
          count += 1
        else
          break
        end
      end
      trailing_zeros[i] = count
    end

    swaps = 0

    (0...n).each do |i|
      required_zeros = n - 1 - i
      j = i

      while j < n && trailing_zeros[j] < required_zeros
        j += 1
      end

      return -1 if j == n

      while j > i
        trailing_zeros[j], trailing_zeros[j - 1] = trailing_zeros[j - 1], trailing_zeros[j]
        j -= 1
        swaps += 1
      end
    end

    swaps
  end
end