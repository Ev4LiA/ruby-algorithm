class Contest505
  # @param {Integer} n
  # @param {Integer} k
  # @return {Integer}
  def sum_of_good_integers(n, k)
    # x must be positive and satisfy abs(n - x) <= k
    left  = [1, n - k].max
    right = n + k

    sum = 0
    (left..right).each do |x|
      # (n & x) == 0 is the compatibility condition
      sum += x if (n & x) == 0
    end

    sum
  end

  # @param {Integer} n
  # @param {Integer} k
  # @return {String[]}
  def generate_valid_strings(n, k)
    result = []

    # backtrack builds the string position by position
    # pos: current index (0-based)
    # prev_one: whether previous bit is '1'
    # cost: current sum of indices with '1'
    # current: array of chars for efficiency
    backtrack = lambda do |pos, prev_one, cost, current|
      # prune if cost already exceeds k
      return if cost > k

      if pos == n
        # reached full length; cost already ≤ k by pruning
        result << current.join
        return
      end

      # Option 1: put '0' at this position
      current[pos] = "0"
      backtrack.call(pos + 1, false, cost, current)

      # Option 2: put '1' if previous is not '1'
      unless prev_one
        current[pos] = "1"
        backtrack.call(pos + 1, true, cost + pos, current)
      end
    end

    backtrack.call(0, false, 0, Array.new(n))
    result
  end

  # @param {Integer[]} nums
  # @param {Integer} m
  # @param {Integer} l
  # @param {Integer} r
  # @return {Integer}
  def maximum_sum(nums, m, l, r)
    n = nums.length

    # prefix sums: pref[i] = sum of nums[0...i]
    pref = Array.new(n + 1, 0)
    0.upto(n - 1) do |i|
      pref[i + 1] = pref[i] + nums[i]
    end

    neg_inf = -(10**18)

    # f_prev[i] = best sum using at most (k-1) subarrays in nums[0...i]
    # f_cur[i]  = best sum using at most k subarrays in nums[0...i]
    f_prev = Array.new(n + 1, neg_inf)
    f_cur  = Array.new(n + 1, neg_inf)

    # With 0 subarrays, best sum is 0 for any prefix
    0.upto(n) { |i| f_prev[i] = 0 }

    best_answer = -Float::INFINITY

    1.upto(m) do |_k|
      0.upto(n) { |i| f_cur[i] = neg_inf }

      # Deque will store [j, value] where
      # value = f_prev[j - 1] - pref[j - 1]
      deque = []

      1.upto(n) do |i|
        left  = i - r + 1   # minimal start index j allowed
        right = i - l + 1   # maximal start index j allowed

        # Add new candidate j = right (if within 1..n) into window
        if right >= 1 && right <= n
          val = f_prev[right - 1] - pref[right - 1]

          # Maintain deque in decreasing order of value
          deque.pop while !deque.empty? && deque[-1][1] <= val
          deque << [right, val]
        end

        # Remove candidates that are out of the left bound
        deque.shift while !deque.empty? && deque[0][0] < left

        # Option 1: don't end a subarray at i
        f_cur[i] = [f_cur[i], f_cur[i - 1]].max

        # Option 2: end a subarray at i if there is any valid start
        next if deque.empty?

        best_val = deque[0][1]
        candidate = best_val + pref[i] # sum of that subarray + best before it
        f_cur[i] = [f_cur[i], candidate].max
      end

      # Update global best; ensure we actually formed at least one subarray
      best_answer = [best_answer, f_cur[n]].max if f_cur[n] > neg_inf / 2

      # Prepare for next k
      f_prev, f_cur = f_cur, f_prev
    end

    best_answer
  end
end
