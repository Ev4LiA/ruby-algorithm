class Contest469
  # @param {Integer} n
  # @return {Integer[]}
  def decimal_representation(n)
    res = []
    i = 0
    while n > 0
      res << ((n % 10) * (10**i)) if n % 10 != 0
      i += 1
      n /= 10
    end
    res.sort!.reverse!
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def split_array(nums)
    n = nums.length

    # Precompute prefix sums
    prefix_sum = Array.new(n + 1, 0)
    (0...n).each { |i| prefix_sum[i + 1] = prefix_sum[i] + nums[i] }

    # can_end_increasing[i] = true if nums[0..i] is strictly increasing
    can_end_increasing = Array.new(n, false)
    can_end_increasing[0] = true
    (1...n).each do |i|
      can_end_increasing[i] = can_end_increasing[i - 1] && nums[i] > nums[i - 1]
    end

    # can_start_decreasing[i] = true if nums[i..n-1] is strictly decreasing
    can_start_decreasing = Array.new(n, false)
    can_start_decreasing[n - 1] = true
    (n - 2).downto(0) do |i|
      can_start_decreasing[i] = can_start_decreasing[i + 1] && nums[i] > nums[i + 1]
    end

    min_diff = Float::INFINITY

    # Try all possible split points
    (1...n).each do |i|
      next unless can_end_increasing[i - 1] && can_start_decreasing[i]

      left_sum = prefix_sum[i]
      right_sum = prefix_sum[n] - prefix_sum[i]
      diff = (left_sum - right_sum).abs
      min_diff = [min_diff, diff].min
    end

    min_diff == Float::INFINITY ? -1 : min_diff
  end

  # @param {Integer} n
  # @param {Integer} l
  # @param {Integer} r
  # @return {Integer}
  def zig_zag_arrays(n, l, r)
    mod = 1_000_000_007
    range = r - l + 1

    # Base case: arrays of length 1 can use any value in [l, r]
    return range if n == 1

    # Dynamic programming approach:
    # up[i] = number of valid sequences ending at position i with last transition being increasing
    # down[i] = number of valid sequences ending at position i with last transition being decreasing
    # We use 1-indexed arrays where i represents the relative position (value - l + 1)
    up = Array.new(range + 1, 0)
    down = Array.new(range + 1, 0)

    # Initialize for length 2:
    # For each position i, count how many valid previous positions exist
    (1..range).each do |i|
      up[i] = i - 1 # Can come from any smaller position (increasing transition)
      down[i] = range - i # Can come from any larger position (decreasing transition)
    end

    # Arrays for prefix sums and next iteration values
    prefix_up = Array.new(range + 1, 0)
    prefix_down = Array.new(range + 1, 0)
    next_up = Array.new(range + 1, 0)
    next_down = Array.new(range + 1, 0)

    # Build sequences of length 3 to n
    (3..n).each do |_len|
      # Compute prefix sums for efficient range sum queries
      # prefix_up[i] = sum of up[1] + up[2] + ... + up[i]
      # prefix_down[i] = sum of down[1] + down[2] + ... + down[i]
      (1..range).each do |i|
        prefix_up[i] = (prefix_up[i - 1] + up[i]) % mod
        prefix_down[i] = (prefix_down[i - 1] + down[i]) % mod
      end

      # For each position j in the new sequence:
      (1..range).each do |j| # rubocop:disable Style/CombinableLoops
        # To avoid monotonic triplets, we need alternating transitions:
        # If current transition is UP (increasing), previous must have been DOWN
        # So we sum all DOWN sequences ending at positions < j
        next_up[j] = prefix_down[j - 1]

        # If current transition is DOWN (decreasing), previous must have been UP
        # So we sum all UP sequences ending at positions > j
        # This equals: sum(up[j+1] to up[range]) = prefix_up[range] - prefix_up[j]
        next_down[j] = (prefix_up[range] - prefix_up[j] + mod) % mod
      end

      # Update arrays for next iteration
      up = next_up
      down = next_down
    end

    # Sum all valid sequences ending with either UP or DOWN transitions
    ans = 0
    (1..range).each do |i|
      ans = (ans + up[i] + down[i]) % mod
    end

    ans
  end

  # @param {Integer} n
  # @param {Integer} l
  # @param {Integer} r
  # @return {Integer}
  def zig_zag_arrays_2(n, l, r)
    mod = 10**9 + 7
    k = r - l + 1

    # Matrix multiplication lambda
    mat_mul = lambda do |a, b|
      n = a.size
      m = b[0].size
      p = b.size
      result = Array.new(n) { Array.new(m, 0) }

      (0...n).each do |i|
        (0...m).each do |j|
          (0...p).each do |k|
            result[i][j] = (result[i][j] + a[i][k] * b[k][j]) % mod
          end
        end
      end
      result
    end

    # Matrix exponentiation lambda
    mat_pow = lambda do |matrix, e|
      n = matrix.size
      # Identity matrix
      ans = Array.new(n) { |i| Array.new(n) { |j| i == j ? 1 : 0 } }
      base = matrix.map(&:dup) # Deep copy

      while e > 0
        if e & 1 == 1
          ans = mat_mul.call(ans, base)
        end
        base = mat_mul.call(base, base)
        e >>= 1
      end
      ans
    end

    # Create M1: upper triangular matrix (i < j gives 1, else 0)
    m1 = Array.new(k) { |i| Array.new(k) { |j| i < j ? 1 : 0 } }

    # Create M2: capacity matrix (k - 1 - max(i, j))
    m2 = Array.new(k) { |i| Array.new(k) { |j| k - 1 - [i, j].max } }

    # Calculate pairs and remainder
    pairs, rem = (n - 1).divmod(2)

    # Matrix exponentiation: A = M2^pairs
    a = mat_pow.call(m2, pairs)

    # If remainder exists, multiply by M1: A = A * M1
    if rem > 0
      a = mat_mul.call(a, m1)
    end

    # Sum all elements in matrix A, multiply by 2, take modulo
    total_sum = a.sum { |row| row.sum }
    (total_sum * 2) % mod
  end
end
