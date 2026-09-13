class Contest519
  # Q1. Cyclically Shift Rows and Columns
  # @param {Integer} n
  # @param {Integer[][]} grid
  # @param {Integer[]} row_shift
  # @param {Integer[]} col_shift
  # @return {Integer[][]}
  def cyclic_shift(n, grid, row_shift, col_shift)
    after_rows = Array.new(n) { Array.new(n) }
    (0...n).each do |i|
      (0...n).each do |j|
        c = (j - row_shift[i] + n) % n
        after_rows[i][c] = grid[i][j]
      end
    end

    result = Array.new(n) { Array.new(n) }
    (0...n).each do |i|
      (0...n).each do |j|
        r = (i - col_shift[j] + n) % n
        result[r][j] = after_rows[i][j]
      end
    end

    result
  end
end
