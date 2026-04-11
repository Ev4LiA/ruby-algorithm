class Contest180
  # @param {Integer} timer
  # @return {String}
  def traffic_signal(timer)
    if timer.zero?
      "Green"
    elsif timer == 30
      "Orange"
    elsif timer > 30 && timer <= 90
      "Red"
    else
      "Invalid"
    end
  end

  # @param {Integer[]} nums
  # @param {Integer} digit
  # @return {Integer}
  def count_digit_occurrences(nums, digit)
    res = 0
    nums.each do |n|
      n.to_s.each_char do |c|
        res += 1 if c == digit.to_s
      end
    end
    res
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def min_operations(nums)
    # Sieve of Eratosthenes to find primes efficiently.
    # Max value of nums[i] is 10^5. We need to find next primes,
    # so sieve should be slightly larger. 110_000 is a safe bet.
    sieve_limit = 110_000
    is_prime_sieve = Array.new(sieve_limit + 1, true)
    is_prime_sieve[0] = is_prime_sieve[1] = false
    (2..Math.sqrt(sieve_limit)).each do |p|
      (p * p..sieve_limit).step(p) { |i| is_prime_sieve[i] = false } if is_prime_sieve[p]
    end

    # Helper to check primality using the sieve
    is_prime = ->(n) { n >= 2 && n < is_prime_sieve.length && is_prime_sieve[n] }

    # Helper to find the next prime >= n
    find_next_prime = lambda do |n|
      p = n
      p += 1 until p < is_prime_sieve.length && is_prime_sieve[p]
      p
    end

    total_ops = 0
    nums.each_with_index do |num, i|
      if i.even?
        # Element at even index must be prime
        unless is_prime.call(num)
          next_p = find_next_prime.call(num)
          total_ops += (next_p - num)
        end
      elsif is_prime.call(num)
        # Element at odd index must be non-prime
        total_ops += if num == 2
                       2 # Next non-prime is 4
                     else
                       1 # Next non-prime for a prime p > 2 is p+1
                     end
      end
    end
    total_ops
  end
end
