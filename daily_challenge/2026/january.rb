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

  # 1411. Number of Ways to Paint N × 3 Grid
  # @param {Integer} n
  # @return {Integer}
  def num_of_ways(n)
    mod = (10**9) + 7
    a = 6
    b = 6
    (2..n).each do |_i|
      new_a = ((2 * a) + (2 * b)) % mod
      new_b = ((2 * a) + (3 * b)) % mod
      a = new_a
      b = new_b
    end

    (a + b) % mod
  end

  # 1390. Four Divisors
  # @param {Integer[]} nums
  # @return {Integer}
  def sum_four_divisors(nums)
    sum = 0
    nums.each do |num|
      divisors = []
      (1..Math.sqrt(num)).each do |i|
        if (num % i).zero?
          divisors << i
          divisors << num / i if i != num / i
        end
      end
      if divisors.length == 4
        sum += divisors.sum
      end
    end

    sum
  end
end
