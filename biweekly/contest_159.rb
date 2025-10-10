class Contest159
  # @param {Integer[]} nums
  # @return {Integer}
  def min_swaps(nums)
    n = nums.length

    # Collect the indices of even numbers in their current order
    even_positions = []
    nums.each_with_index { |num, idx| even_positions << idx if num.even? }

    even_cnt = even_positions.length

    # Helper lambda to compute cost when even numbers should occupy the given starting index (0 or 1)
    calc_cost = lambda do |even_start|
      cost = 0
      even_positions.each_with_index do |pos, k|
        target = even_start + 2 * k
        cost += (pos - target).abs
      end
      cost
    end

    best = Float::INFINITY

    # Case 1: array starts with an even element (pattern: even, odd, even, ...)
    if even_cnt == (n + 1) / 2
      best = [best, calc_cost.call(0)].min
    end

    # Case 2: array starts with an odd element (pattern: odd, even, odd, ...)
    if even_cnt == n / 2
      best = [best, calc_cost.call(1)].min
    end

    best.finite? ? best : -1
  end

  # @param {Integer[][]} coords
  # @return {Integer}
  def max_area(coords)
    n = coords.length
    return -1 if n < 3

    # Global extremes
    min_x = Float::INFINITY
    max_x = -Float::INFINITY
    min_y = Float::INFINITY
    max_y = -Float::INFINITY

    # Hashes to store min/max per row (y) and column (x)
    row = {}
    col = {}

    coords.each do |point|
      x, y = point

      # Update global extremes
      min_x = x if x < min_x
      max_x = x if x > max_x
      min_y = y if y < min_y
      max_y = y if y > max_y

      # Update horizontal info for this y (row)
      if row.key?(y)
        row[y][0] = x if x < row[y][0] # min x
        row[y][1] = x if x > row[y][1] # max x
      else
        row[y] = [x, x]
      end

      # Update vertical info for this x (column)
      if col.key?(x)
        col[x][0] = y if y < col[x][0] # min y
        col[x][1] = y if y > col[x][1] # max y
      else
        col[x] = [y, y]
      end
    end

    best = -1

    # Evaluate triangles with horizontal base (same y)
    row.each do |y, (lx, rx)|
      next if lx == rx # need at least two distinct points on the row

      base = rx - lx
      height = [y - min_y, max_y - y].max
      next if height.zero?

      area2 = base * height
      best = area2 if area2 > best
    end

    # Evaluate triangles with vertical base (same x)
    col.each do |x, (ly, ry)|
      next if ly == ry # need at least two distinct points on the column

      base = ry - ly
      height = [x - min_x, max_x - x].max
      next if height.zero?

      area2 = base * height
      best = area2 if area2 > best
    end

    best
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def prime_subarray(nums, k)
    # Sieve of Eratosthenes up to the largest value in nums for fast primality tests
    max_val = nums.max
    prime_numbers = Array.new(max_val + 1, true)
    prime_numbers[0] = prime_numbers[1] = false
    (2..Math.sqrt(max_val).floor).each do |i|
      next unless prime_numbers[i]
      (i * i).step(max_val, i) { |j| prime_numbers[j] = false }
    end

    left = 0
    ans = 0

    # Deques for tracking min and max prime values in current window
    min_q = []   # increasing
    max_q = []   # decreasing

    # Queue of indices of primes currently inside the window (in order)
    prime_idx = []

    nums.each_with_index do |val, right|
      if prime_numbers[val]
        # Maintain monotone queues for min/max within window (only primes matter)
        while !min_q.empty? && min_q[-1] > val
          min_q.pop
        end
        min_q << val

        while !max_q.empty? && max_q[-1] < val
          max_q.pop
        end
        max_q << val

        prime_idx << right
      end

      # Shrink window until the prime gap condition holds
      while !min_q.empty? && (max_q[0] - min_q[0] > k)
        # Move left edge
        if prime_numbers[nums[left]]
          # Remove leaving prime from auxiliary structures where necessary
          min_q.shift if nums[left] == min_q[0]
          max_q.shift if nums[left] == max_q[0]
          prime_idx.shift if prime_idx[0] == left
        end
        left += 1
      end

      # Count valid subarrays ending at index `right`
      if prime_idx.length >= 2
        second_last_prime_idx = prime_idx[-2]
        ans += second_last_prime_idx - left + 1
      end
    end

    ans
  end
end

solution = Contest159.new
puts solution.max_area([[1,1],[6,10],[6,5]])
