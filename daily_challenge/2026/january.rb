class January2026
  # 66. Plus One
  # @param {Integer[]} digits
  # @return {Integer[]}
  def plus_one(digits)
    n = digits.length
    (n - 1).downto(0) do |i|
      if digits[i] < 9
        digits[i] += 1
        return digits
      end
      digits[i] = 0
    end
    [1] + digits
  end
end
