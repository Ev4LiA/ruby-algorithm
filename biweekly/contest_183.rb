class Contest183
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_swaps(nums)
    n = nums.length

    # Count how many non-zero elements
    non_zero_count = nums.count { |x| x != 0 }
    
    # Count how many non-zero elements are already in the first non_zero_count positions
    correct_non_zero_in_prefix = 0
    (0...non_zero_count).each do |i|
      correct_non_zero_in_prefix += 1 if nums[i] != 0
    end

    # Each swap can fix one misplaced non-zero in the prefix
    non_zero_count - correct_non_zero_in_prefix
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def min_operations(nums, k)
    n = nums.length

    # Precompute remainders mod k to avoid recomputing
    remainders = nums.map { |v| v % k }

    # For each index and each possible target remainder r in [0, k-1],
    # precompute minimal cost to change nums[i] to some value with remainder r.
    # cost[i][r] = min operations.
    cost = Array.new(n) { Array.new(k, 0) }

    (0...n).each do |i|
      a = remainders[i]
      (0...k).each do |r|
        forward  = (a - r) % k   # decrease moves
        backward = (r - a) % k   # increase moves
        cost[i][r] = [forward, backward].min
      end
    end

    # Try all ordered pairs (x, y) with x != y
    ans = Float::INFINITY

    (0...k).each do |x|
      (0...k).each do |y|
        next if x == y

        total = 0

        (0...n).each do |i|
          if i.even?
            total += cost[i][x]
          else
            total += cost[i][y]
          end

          # Small pruning (optional): if already worse than best, break
          break if total >= ans
        end

        ans = [ans, total].min
      end
    end

    ans
  end
end
