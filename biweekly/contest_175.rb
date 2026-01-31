class Contest175
  # @param {String} s
  # @return {String}
  def reverse_by_type(s)
    chars = s.chars
    letter_indices = []
    letter_chars = []
    special_indices = []
    special_chars = []

    chars.each_with_index do |c, i|
      if c.between?('a', 'z')
        letter_indices << i
        letter_chars << c
      else
        special_indices << i
        special_chars << c
      end
    end

    result = chars.dup
    letter_chars.reverse.each_with_index { |c, i| result[letter_indices[i]] = c }
    special_chars.reverse.each_with_index { |c, i| result[special_indices[i]] = c }
    result.join
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_k(nums)
    # The problem description has a typo: "nonPositive(nums, k) <= k2".
    # Based on the examples and further testing, it is assumed that the condition
    # is nonPositive(nums, k) <= k * k.
    #
    # nonPositive(nums, k) is the total number of operations.
    # For a number `n`, it takes `ceil(n/k)` operations.
    # In integer arithmetic, this is `(n - 1) / k + 1`.
    #
    # So we need to find the minimum positive integer k such that:
    # sum((num - 1) / k + 1 for num in nums) <= k * k
    #
    # Let check(k) be the function that evaluates this condition.
    # The function `nonPositive(nums, k)` is monotonically decreasing with `k`.
    # The function `k*k` is monotonically increasing with `k`.
    # Therefore, the function `f(k) = nonPositive(nums, k) - k*k` is monotonically decreasing.
    # This allows us to use binary search to find the minimum `k` that satisfies `f(k) <= 0`.

    low = 1
    # Max value of num is 10^5, max length is 10^5.
    # If k is around 2*10^5, ops (nonPositive) would be around nums.length (10^5).
    # k*k would be (2*10^5)^2 = 4*10^10. 10^5 <= 4*10^10 is true.
    # So an upper bound of 2*10^5 is sufficient.
    high = 200_000
    ans = high # Initialize ans with a value that is guaranteed to be a valid k, if found.

    while low <= high
      mid = low + ((high - low) / 2)
      # Ensure mid is at least 1, as k must be a positive integer.
      # If low and high were both 0, mid could be 0, but our low starts at 1.
      # This check is mostly for robustness.
      if mid == 0
        low = 1 # Should not happen with current low=1 initialization, but good practice.
        next
      end

      # Calculate nonPositive(nums, mid)
      ops = nums.sum { |num| ((num - 1) / mid) + 1 }

      # Check the condition: nonPositive(nums, mid) <= mid * mid
      if ops <= mid * mid
        ans = mid # This mid is a possible answer, try to find a smaller k
        high = mid - 1
      else
        low = mid + 1 # mid is too small, need a larger k
      end
    end

    ans
  end

  # Finds the length of the longest strictly increasing subsequence
  # whose elements have a non-zero bitwise AND.
  #
  # @param {Integer[]} nums
  # @return {Integer}
  def longest_and_subsequence(nums)
    max_len = 0
    # 10^9 is less than 2^30, so we check bits from 0 to 29.
    30.times do |b|
      bit_mask = 1 << b
      sub_nums = nums.select { |num| (num & bit_mask) != 0 }

      next if sub_nums.empty?

      lis_len = calculate_lis(sub_nums)
      max_len = [max_len, lis_len].max
    end
    max_len
  end

  private

  # Calculates the length of the Longest Increasing Subsequence
  # using a standard O(n log n) algorithm.
  def calculate_lis(arr)
    tails = []
    arr.each do |num|
      if tails.empty? || num > tails.last
        tails << num
      else
        # Find the first element in tails that is >= num
        # and replace it. This is equivalent to `lower_bound`.
        idx = tails.bsearch_index { |x| x >= num }
        tails[idx] = num if idx
      end
    end
    tails.length
  end
end
