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
end
