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
end
