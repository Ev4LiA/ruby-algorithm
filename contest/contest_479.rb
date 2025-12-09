class Contest479
  # @param {Integer[]} nums
  # @return {Integer[]}
  def sort_by_reflection(nums)
    nums.sort_by do |num|
      binary = num.to_s(2)
      reflection = binary.reverse.to_i(2)
      [reflection, num]
    end
  end

  # @param {Integer} n
  # @return {Integer}
  def largest_prime(n)
    return 0 if n < 2
    return 2 if n == 2

    is_prime = sieve(n)
    return 0 unless is_prime

    max_prime = 0
    sum = 0

    (2..n).each do |i|
      next unless is_prime[i]

      sum += i
      break if sum > n

      max_prime = sum if is_prime[sum] && sum > max_prime
    end

    max_prime
  end

  private

  def sieve(n)
    is_prime = Array.new(n + 1, true)
    is_prime[0] = false
    is_prime[1] = false

    (2..Math.sqrt(n).to_i).each do |i|
      next unless is_prime[i]

      (i * i..n).step(i) do |j|
        is_prime[j] = false
      end
    end

    is_prime
  end

  # @param {Integer} hp
  # @param {Integer[]} damage
  # @param {Integer[]} requirement
  # @return {Integer}
  def total_score(hp, damage, requirement); end
end
