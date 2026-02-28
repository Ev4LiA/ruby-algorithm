class Contest177
  # @param {Integer[]} nums
  # @return {Integer[]}
  def min_distinct_freq_pair(nums)
    return [-1, -1] if nums.length < 2

    nums.sort!

    freq = nums.tally
    smallest_count = freq[nums[0]]

    # Traverse the frequency hash to find the first number with a different frequency to the smallest count.
    freq.each do |num, count|
      next if count == smallest_count

      return [nums[0], num]
    end
    [-1, -1]
  end

  # @param {String} s
  # @param {Integer} k
  # @return {String}
  def merge_characters(s, k)
    loop do
      merge_found = false
      char_to_remove_idx = -1

      (0...s.length).each do |i|
        (i + 1...s.length).each do |j|
          # Optimization: If distance is greater than k, subsequent characters for this 'i' will also be too far.
          break if j - i > k

          next unless s[i] == s[j]

          # Found the merge pair with the smallest left index (i)
          # and for that i, the smallest right index (j).
          char_to_remove_idx = j
          merge_found = true
          break
        end
        break if merge_found
      end

      break unless merge_found

      # Perform the merge by removing the character at the found index.
      s.slice!(char_to_remove_idx)

      # No more merges are possible in the entire string, so we are done.
    end
    s
  end

  # @param {Integer[]} nums
  # @return {Integer[]}
  def make_parity_alternating(nums)
    n = nums.length
    return [0, 0] if n <= 1

    # Calculate the cost to transform to each of the two possible patterns.
    # Pattern A: E, O, E, O, ...
    # Pattern B: O, E, O, E, ...
    cost_a = 0
    cost_b = 0
    (0...n).each do |i|
      num_is_even = nums[i].even?
      # For Pattern A (starts with Even)
      cost_a += 1 if i.even? != num_is_even
      # For Pattern B (starts with Odd)
      cost_b += 1 if i.odd? != num_is_even
    end

    min_ops = [cost_a, cost_b].min
    min_range = Float::INFINITY

    # If Pattern A is one of the optimal-cost patterns, calculate its best range.
    min_range = [min_range, calculate_min_range(nums, true)].min if cost_a == min_ops

    # If Pattern B is one of the optimal-cost patterns, calculate its best range.
    min_range = [min_range, calculate_min_range(nums, false)].min if cost_b == min_ops

    [min_ops, min_range]
  end

  private

  # Solves the "smallest range covering elements from k lists" problem
  # using a sliding window approach.
  def calculate_min_range(nums, start_is_even)
    n = nums.length
    return 0 if n <= 1

    # 1. Create a list of all candidate values for the final array.
    # Each candidate is a pair [value, original_index].
    candidates = []
    (0...n).each do |i|
      target_is_even = start_is_even ? i.even? : i.odd?
      num_is_even = nums[i].even?

      if target_is_even == num_is_even
        # Parity matches, so the number must not change.
        candidates << [nums[i], i]
      else
        # Parity mismatches, number must change by +1 or -1.
        candidates << [nums[i] - 1, i]
        candidates << [nums[i] + 1, i]
      end
    end

    candidates.sort!

    # 2. Use a sliding window to find the smallest range covering all indices.
    min_diff = Float::INFINITY
    counts = Array.new(n, 0)
    covered_indices = 0
    left = 0

    (0...candidates.length).each do |right|
      _r_val, r_idx = candidates[right]

      # Expand the window to the right
      counts[r_idx] += 1
      covered_indices += 1 if counts[r_idx] == 1

      # While the window is valid (covers all n indices),
      # update the min_diff and shrink from the left.
      while covered_indices == n
        current_diff = candidates[right][0] - candidates[left][0]
        min_diff = [min_diff, current_diff].min

        _l_val, l_idx = candidates[left]
        counts[l_idx] -= 1
        covered_indices -= 1 if counts[l_idx].zero?
        left += 1
      end
    end

    min_diff
  end

  # @param {Integer} l
  # @param {Integer} r
  # @param {Integer} k
  # @return {Integer}
  def sum_of_numbers(l, r, k)
    mod = 10**9 + 7

    # power function for modular exponentiation: (base^exp) % mod
    power = lambda do |base, exp|
      res = 1
      base %= mod
      while exp > 0
        res = (res * base) % mod if exp.odd?
        base = (base * base) % mod
        exp >>= 1
      end
      res
    end

    # Let n be the number of digit choices.
    n = r - l + 1

    # The total sum can be found by calculating the contribution of each digit place.
    # TotalSum = (Sum of digit choices) * (Combinations for other places) * (Sum of place values)
    #
    # 1. Sum of digit choices (S):
    #    S = l + (l+1) + ... + r = n * (l+r) / 2
    s = (n * (l + r) / 2)

    # 2. Combinations for other places:
    #    For each position, there are k-1 other positions that can be filled in n^(k-1) ways.
    n_pow_km1 = power.call(n, k - 1)

    # 3. Sum of place values (1 + 10 + ... + 10^(k-1)):
    #    This is a geometric series sum: (10^k - 1) / 9.
    #    Division by 9 is done by multiplying with the modular inverse of 9.
    inv9 = power.call(9, mod - 2)
    term_10_k = power.call(10, k)
    sum_of_powers_of_10 = ((term_10_k - 1 + mod) % mod * inv9) % mod

    # Combine the components, applying modulo at each step to prevent overflow.
    result = (s % mod * n_pow_km1) % mod
    result = (result * sum_of_powers_of_10) % mod

    result
  end
end
