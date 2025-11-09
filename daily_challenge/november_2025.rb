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
end
