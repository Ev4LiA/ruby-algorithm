class Contest171
  # @param {Integer} num
  # @return {Boolean}
  def complete_prime(num)
    s = num.to_s
    n = s.length

    # Check all prefixes (first k digits for k = 1 to n)
    # Check all suffixes (last k digits for k = 1 to n)
    (1..n).each do |k|
      prefix = s[0, k].to_i
      return false unless prime?(prefix)

      suffix = s[-k, k].to_i
      return false unless prime?(suffix)
    end

    true
  end

  private

  def prime?(n)
    return false if n <= 1
    return true if n <= 3
    return false if n.even? || n % 3 == 0

    # Check for divisors of the form 6k ± 1
    i = 5
    while i * i <= n
      return false if n % i == 0 || n % (i + 2) == 0

      i += 6
    end
    true
  end

  # @param {Integer[]} nums
  # @return {Integer[]}
  def min_operations(nums)
    nums.map { |num| min_ops_for_num(num) }
  end

  def min_ops_for_num(num)
    return 0 if binary_palindrome?(num)

    # Search for nearest palindrome above and below
    up = num + 1
    down = num - 1

    while !binary_palindrome?(up) && !binary_palindrome?(down)
      up += 1
      down -= 1
    end

    if binary_palindrome?(up) && binary_palindrome?(down)
      [up - num, num - down].min
    elsif binary_palindrome?(up)
      up - num
    else
      num - down
    end
  end

  def binary_palindrome?(n)
    return false if n <= 0

    binary = n.to_s(2)
    binary == binary.reverse
  end

  # @param {Integer[]} technique1
  # @param {Integer[]} technique2
  # @param {Integer} k
  # @return {Integer}
  def max_points(technique1, technique2, k)
    n = technique1.length
    return 0 if n.zero?

    # Calculate gain for each task: gain[i] = technique1[i] - technique2[i]
    gains = (0...n).map { |i| [i, technique1[i] - technique2[i]] }

    # Sort by gain descending (highest gain first)
    gains.sort_by! { |_idx, gain| -gain }

    total = 0

    # Force top k tasks to use technique1 (these have highest gain or least negative gain)
    (0...k).each do |i|
      idx = gains[i][0]
      total += technique1[idx]
    end

    # For remaining tasks, choose the best option
    (k...n).each do |i|
      idx = gains[i][0]
      total += [technique1[idx], technique2[idx]].max
    end

    total
  end
end
