require 'set'

class Contest157
  # @param {String} s
  # @return {Integer}
  def sum_of_largest_primes(s)

    primes = Set.new

    (0...s.length).each do |i|
      (i + 1..s.length).each do |j|
        substring = s[i...j]
        num = substring.to_i
        primes.add(num) if prime?(num)
      end
    end

    primes.to_a.sort.reverse.take(3).sum
  end

  private

  def prime?(n)
    return false if n <= 1
    return true if n <= 3
    return false if n % 2 == 0 || n % 3 == 0

    # Check for divisors of the form 6k ± 1
    i = 5
    while i * i <= n
      return false if n % i == 0 || n % (i + 2) == 0
      i += 6
    end
    true
  end


  def running_sum(nums)
    nums.each_with_index do |num, index|
      nums[index] = nums[index - 1] + num if index > 0
    end
    nums
  end
end
