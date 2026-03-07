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

  # 1582. Special Positions in a Binary Matrix
  # @param {Integer[][]} mat
  # @return {Integer}
  def num_special(mat)
    rows = mat.length
    cols = mat[0].length
    row_counts = Array.new(rows, 0)
    col_counts = Array.new(cols, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        if mat[i][j] == 1
          row_counts[i] += 1
          col_counts[j] += 1
        end
      end
    end

    special_count = 0

    (0...rows).each do |i|
      (0...cols).each do |j|
        special_count += 1 if mat[i][j] == 1 && row_counts[i] == 1 && col_counts[j] == 1
      end
    end

    special_count
  end

  # 1758. Minimum Changes To Make Alternating Binary String
  # @param {String} s
  # @return {Integer}
  def min_operations(s)
    count1 = 0
    count2 = 0

    s.chars.each_with_index do |char, index|
      if char == "0"
        count1 += 1 if index.even?
        count2 += 1 if index.odd?
      else
        count1 += 1 if index.odd?
        count2 += 1 if index.even?
      end
    end

    [count1, count2].min
  end

  # 1784. Check if Binary String Has at Most One Segment of Ones
  # @param {String} s
  # @return {Boolean}
  def check_onces(s)
    !s.include?("01")
  end

  # 1888. Minimum Number of Flips to Make the Binary String Alternating
  # @param {String} s
  # @return {Integer}
  def min_flips(s)
    n = s.length
    pre = Array.new(n) { [0, 0] }

    (0...n).each do |i|
      ch = s[i]
      pre[i][0] = (i == 0 ? 0 : pre[i - 1][1]) + (ch == "1" ? 1 : 0)
      pre[i][1] = (i == 0 ? 0 : pre[i - 1][0]) + (ch == "0" ? 1 : 0)
    end

    ans = [pre[n - 1][0], pre[n - 1][1]].min

    if n.odd?
      suf = Array.new(n) { [0, 0] }

      (n - 1).downto(0) do |i|
        ch = s[i]
        suf[i][0] = (i == n - 1 ? 0 : suf[i + 1][1]) + (ch == "1" ? 1 : 0)
        suf[i][1] = (i == n - 1 ? 0 : suf[i + 1][0]) + (ch == "0" ? 1 : 0)
      end

      (0...(n - 1)).each do |i|
        ans = [ans, pre[i][0] + suf[i + 1][0]].min
        ans = [ans, pre[i][1] + suf[i + 1][1]].min
      end
    end

    ans
  end
end
