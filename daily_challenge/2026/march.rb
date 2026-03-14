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

  # 1980. Find Unique Binary String
  # @param {String[]} nums
  # @return {String}
  def find_different_binary_string(nums)
    n = nums.length
    result = ""

    (0...n).each do |i|
      result += nums[i][i] == "0" ? "1" : "0"
    end

    result
  end

  # 3129. Find All Possible Stable Binary Arrays I
  # params {Integer} zeros
  # params {Integer} one
  # params {Integer} limit
  # return {Integer}
  def count_stable_arrays(zero, one, limit)
    mod = (10**9) + 7
    dp = Array.new(zero + 1) { Array.new(one + 1) { [0, 0] } }
    dp[0][0][0] = dp[0][0][1] = 1

    (0..zero).each do |i|
      (0..one).each do |j|
        (1..limit).each do |k|
          dp[i][j][1] = (dp[i][j][1] + (i - k >= 0 ? dp[i - k][j][0] : 0)) % mod
          dp[i][j][0] = (dp[i][j][0] + (j - k >= 0 ? dp[i][j - k][1] : 0)) % mod
        end
      end
    end
    (dp[zero][one][0] + dp[zero][one][1]) % mod
  end

  # 3130. Find All Possible Stable Binary Arrays II
  # params {Integer} zeros
  # params {Integer} one
  # params {Integer} limit
  # return {Integer}
  def count_stable_arrays_ii(zero, one, limit)
    mod = (10**9) + 7
    memo = Array.new(zero + 1) { Array.new(one + 1) { [-1, -1] } }

    define_method(:dp) do |zero, one, last_bit|
      return 0 if zero < 0 || one < 0

      if zero == 0
        return last_bit == 0 || one > limit ? 0 : 1
      elsif one == 0
        return last_bit == 1 || zero > limit ? 0 : 1
      end

      if memo[zero][one][last_bit] == -1
        res = 0
        if last_bit == 0
          res = (dp(zero - 1, one, 0) + dp(zero - 1, one, 1)) % mod
          res = (res - dp(zero - limit - 1, one, 1) + mod) % mod if zero > limit
        else
          res = (dp(zero, one - 1, 0) + dp(zero, one - 1, 1)) % mod
          res = (res - dp(zero, one - limit - 1, 0) + mod) % mod if one > limit
        end
        memo[zero][one][last_bit] = res % mod
      end

      memo[zero][one][last_bit]
    end

    (dp(zero, one, 0) + dp(zero, one, 1)) % mod
  end

  # 1009. Complement of Base 10 Integer
  # @param {Integer} n
  # @return {Integer}
  def bitwise_complement(n)
    return 1 if n == 0

    mask = 1
    mask <<= 1 while mask <= n

    (mask - 1) ^ n
  end

  # 1415. The k-th Lexicographical String of All Happy Strings of Length n
  # @param {Integer} n
  # @param {Integer} k
  # @return {String}
  def get_happy_string(n, k)
    total_strings = 3 * (2**(n - 1))
    return "" if k > total_strings

    k -= 1 # 0-indexed
    result = ""
    prev_char = nil

    n.times do |i|
      m = 2**(n - 1 - i)
      available_chars = %w[a b c]
      available_chars.delete(prev_char) if prev_char

      char_index = k / m
      char = available_chars[char_index]
      result += char

      k %= m
      prev_char = char
    end

    result
  end
end
