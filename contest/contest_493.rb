class Contest493
  # @param {Integer} n
  # @return {Integer}
  def count_commas(n)
    total_commas = 0
    divisor = 1000

    while n >= divisor
      total_commas += (n - divisor + 1)
      # On 64-bit systems, Ruby integers can handle this multiplication
      # without overflow for any reasonable n.
      divisor *= 1000
    end

    total_commas
  end

  # @param {Integer} n
  # @return {Integer}
  def count_commas_2(n)
    total_commas = 0
    divisor = 1000

    while n >= divisor
      total_commas += (n - divisor + 1)
      divisor *= 1000
    end

    total_commas
  end
end
