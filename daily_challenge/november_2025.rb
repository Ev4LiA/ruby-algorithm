class November2025
  # 1611. Minimum One Bit Operations to Make Integers Zero
  # @param {Integer} n
  # @return {Integer}
  def minimum_one_bit_operations(n)
    return 0 if n == 0

    k = 0
    curr = 1
    while curr * 2 <= n
      curr *= 2
      k += 1
    end

    (1 << (k + 1)) - 1 - minimum_one_bit_operations(n ^ curr)
  end

  # 2169. Count Operations to Obtain Zero
  # @param {Integer} num1
  # @param {Integer} num2
  # @return {Integer}
  def count_operations(num1, num2)
    res = 0

    while !num1.zero? && !num2.zero?
      res += num1 / num2
      num1 %= num2
      num1, num2 = num2, num1
    end

    res
  end

  # 3542. Minimum Operations to Convert All Elements to Zero
  # @param {Integer[]} nums
  # @return {Integer}
  def min_operations(nums)
    stack = []
    res = 0
    nums.each do |num|
      stack.pop while !stack.empty? && stack.last > num
      next if num.zero?

      if stack.empty? || stack.last < num
        res += 1
        stack << num
      end
    end

    res
  end

  # 474. Ones and Zeroes
  # @param {String[]} strs
  # @param {Integer} m
  # @param {Integer} n
  # @return {Integer}
  def find_max_form(strs, m, n)
    dp = Array.new(m + 1) { Array.new(n + 1, 0) }
    strs.each do |str|
      zeros = str.count("0")
      ones = str.count("1")
      m.downto(zeros) do |i|
        n.downto(ones) do |j|
          dp[i][j] = [dp[i][j], dp[i - zeros][j - ones] + 1].max
        end
      end
    end
    dp[m][n]
  end

  # 2654. Minimum Number of Operations to Make All Array Elements Equal to 1
  # @param {Integer[]} nums
  # @return {Integer}
  def min_operations(nums)
    n = nums.length
    num1 = 0
    g = 0
    nums.each do |num|
      num1 += 1 if num == 1
      g = gcd(g, num)
    end

    return n - num1 if num1.positive?
    return -1 if g > 1

    min_len = n
    nums.each_with_index do |_num, i|
      current_gcd = 0
      (i...n).each do |j|
        current_gcd = gcd(current_gcd, nums[j])
        if current_gcd == 1
          min_len = [min_len, j - i + 1].min
          break
        end
      end
    end
    min_len + n - 2
  end

  def gcd(a, b)
    until b.zero?
      a %= b
      a, b = b, a
    end
    a
  end

  # 2536. Increment Submatrices by One
  # @param {Integer} n
  # @param {Integer[][]} queries
  # @return {Integer[][]}
  def range_add_queries(n, queries)
    diff = Array.new(n + 1) { Array.new(n + 1, 0) }
    queries.each do |query|
      row1 = query[0]
      col1 = query[1]
      row2 = query[2]
      col2 = query[3]
      diff[row1][col1] += 1
      diff[row2 + 1][col1] -= 1
      diff[row1][col2 + 1] -= 1
      diff[row2 + 1][col2 + 1] += 1
    end

    mat = Array.new(n) { Array.new(n, 0) }
    (0...n).each do |i|
      (0...n).each do |j|
        x1 = i.zero? ? 0 : mat[i - 1][j]
        x2 = j.zero? ? 0 : mat[i][j - 1]
        x3 = i.zero? || j.zero? ? 0 : mat[i - 1][j - 1]
        mat[i][j] = diff[i][j] + x1 + x2 - x3
      end
    end
    mat
  end

  # 3234. Count the Number of Substrings With Dominant Ones
  # @param {String} s
  # @return {Integer}
  def number_of_substrings(s)
    n = s.length
    pre = Array.new(n + 1, 0)
    pre[0] = -1
    s.each_char.with_index do |_char, i|
      pre[i + 1] = if i.zero? || (i.positive? && s[i - 1] == "0")
                     i
                   else
                     pre[i]
                   end
    end

    # Index:  0  1  2  3  4
    # String: 1  0  1  1  0
    # pre:   -1  0  1  1  1  4
    #       ↑  ↑  ↑  ↑  ↑  ↑
    #       0  1  2  3  4  5

    res = 0
    (1..n).each do |i|
      count0 = s[i - 1] == "0" ? 1 : 0
      j = i

      while j.positive? && count0 * count0 <= n
        count1 = (i - pre[j]) - count0
        res += [j - pre[j], count1 - (count0 * count0) + 1].min if count0 * count0 <= count1
        j = pre[j]
        count0 += 1
      end
    end

    res
  end

  # 1513. Number of Substrings With Only 1s
  # @param {String} s
  # @return {Integer}
  def num_sub(s)
    mod = (10**9) + 7
    ans = 0
    l = 0
    n = s.length
    while l < n
      unless s[l] == "1"
        l += 1
        next
      end

      r = l
      r += 1 while r < n && s[r] == "1"
      ans = (ans + ((r - l + 1) * (r - l) / 2)) % mod
      l = r
    end
    ans
  end

  # 1437. Check If All 1's Are at Least Length K Places Away
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Boolean}
  def k_length_apart(nums, k)
    first_one = nums.find_index(1)
    return true if first_one.nil?

    (first_one + 1...nums.length).each do |i|
      next unless nums[i] == 1

      return false if i - first_one - 1 < k

      first_one = i
    end

    true
  end

  # 717. 1-bit and 2-bit Characters
  # # @param {Integer[]} bits
  # @return {Boolean}
  def is_one_bit_character(bits)
    i = 0
    while i < bits.length - 1
      i += if bits[i] == 0
             1
           else
             2
           end
    end
    i == bits.length - 1
  end

  # 2154. Keep Multiplying Found Values by Two
  # @param {Integer[]} nums
  # @param {Integer} original
  # @return {Integer}
  def find_final_value(nums, original)
    nums.sort!
    nums.each do |num|
      original *= 2 if num == original
    end
    original
  end
end
