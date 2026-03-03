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
        break unless grid[i][j] == 0

        count += 1
      end
      trailing_zeros[i] = count
    end

    swaps = 0

    (0...n).each do |i|
      required_zeros = n - 1 - i
      j = i

      j += 1 while j < n && trailing_zeros[j] < required_zeros

      return -1 if j == n

      while j > i
        trailing_zeros[j], trailing_zeros[j - 1] = trailing_zeros[j - 1], trailing_zeros[j]
        j -= 1
        swaps += 1
      end
    end

    swaps
  end

  # 1545. Find Kth Bit in Nth Binary String
  # @param {Integer} n
  # @param {Integer} k
  # @return {Character}
  def find_kth_bit(n, k)
    return "0" if n == 1

    len = 1 << n
    if k < len / 2
      find_kth_bit(n - 1, k)
    elsif k == len / 2
      "1"
    else
      bit = find_kth_bit(n - 1, len - k)
      bit == "0" ? "1" : "0"
    end
  end
end
