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

  # 961. N-Repeated Element in Size 2N Array
  # @param {Integer[]} nums
  # @return {Integer}
  def repeated_n_times(nums)
    hash = Hash.new(0)

    nums.each do |n|
      hash[n] += 1
      return n if hash[n] == 2
    end
  end
end
