class August2026
  # 486. Predict the Winner
  # @param {Integer[]} nums
  # @return {Boolean}
  def predict_the_winner(nums)
    n = nums.size
    # dp[i][j] = the max score difference (current player - opponent)
    # achievable on the subarray nums[i..j]
    dp = Array.new(n) { Array.new(n, 0) }

    # base case: single element -> current player takes it
    (0...n).each { |i| dp[i][i] = nums[i] }

    # build up by increasing subarray length
    (1...n).each do |len|
      (0...(n - len)).each do |i|
        j = i + len
        take_left  = nums[i] - dp[i + 1][j]
        take_right = nums[j] - dp[i][j - 1]
        dp[i][j] = [take_left, take_right].max
      end
    end

    dp[0][n - 1] >= 0
  end

  # 877. Stone Game
  # @param {Integer[]} piles
  # @return {Boolean}
  def stone_game(piles)
    n = piles.length
    # dp[i][j] = max score difference (current player - other) for piles[i..j]
    dp = Array.new(n) { Array.new(n, 0) }

    # base case: single pile — current player takes it
    (0...n).each { |i| dp[i][i] = piles[i] }

    # build up by interval length
    (2..n).each do |len|
      (0..n - len).each do |i|
        j = i + len - 1
        take_left  = piles[i] - dp[i + 1][j]
        take_right = piles[j] - dp[i][j - 1]
        dp[i][j] = [take_left, take_right].max
      end
    end

    dp[0][n - 1] > 0
  end

  # 1406. Stone Game III
  # @param {Integer[]} stone_value
  # @return {String}
  def stone_game_iii(stone_value)
    n = stone_value.size
    # dp[i] = best score difference (current player - opponent)
    # achievable starting from index i, playing optimally.
    dp = Array.new(n + 1, 0)

    (n - 1).downto(0) do |i|
      take = 0
      best = -Float::INFINITY
      # Take 1, 2, or 3 stones from the front of the remaining row.
      (0..2).each do |k|
        break if i + k >= n

        take += stone_value[i + k]
        # Current gain minus the best the opponent can then achieve.
        best = [best, take - dp[i + k + 1]].max
      end
      dp[i] = best
    end

    if dp[0].positive?
      "Alice"
    elsif dp[0].negative?
      "Bob"
    else
      "Tie"
    end
  end

  # 3731. Find Missing Elements
  # @param {Integer[]} nums
  # @return {Integer[]}
  def find_missing_elements(nums)
    present = nums.to_set
    (nums.min..nums.max).reject { |n| present.include?(n) }
  end

  # 3310. Remove Methods From Project
  # @param {Integer} n
  # @param {Integer} k
  # @param {Integer[][]} invocations
  # @return {Integer[]}
  def remaining_methods(n, k, invocations)
    # Build adjacency list
    adj = Array.new(n) { [] }
    invocations.each { |a, b| adj[a] << b }

    # DFS from k to mark all suspicious methods
    suspicious = Array.new(n, false)
    stack = [k]
    suspicious[k] = true
    until stack.empty?
      node = stack.pop
      adj[node].each do |nxt|
        unless suspicious[nxt]
          suspicious[nxt] = true
          stack << nxt
        end
      end
    end

    # If any non-suspicious method invokes a suspicious one, we can't remove the group
    invocations.each do |a, b|
      return (0...n).to_a if !suspicious[a] && suspicious[b]
    end

    # Otherwise return all non-suspicious methods
    (0...n).reject { |i| suspicious[i] }
  end

  # 3345. Smallest Divisible Digit Product I
  # @param {Integer} n
  # @param {Integer} t
  # @return {Integer}
  def smallest_number(n, t)
    num = n
    loop do
      product = num.digits.reduce(:*)
      return num if product % t == 0

      num += 1
    end
  end

  # 1510. Stone Game IV
  # @param {Integer} n
  # @return {Boolean}
  def winner_square_game(n)
    # dp[i] = true if the player to move wins with i stones remaining
    dp = Array.new(n + 1, false)

    (1..n).each do |i|
      k = 1
      while k * k <= i
        # If any move leaves the opponent in a losing state, current player wins
        unless dp[i - (k * k)]
          dp[i] = true
          break
        end
        k += 1
      end
    end

    dp[n]
  end

  # 2996. Smallest Missing Integer Greater Than Sequential Prefix Sum
  # @param {Integer[]} nums
  # @return {Integer}
  def missing_integer(nums)
    # Sum the longest sequential prefix
    sum = nums[0]
    (1...nums.length).each do |i|
      break unless nums[i] == nums[i - 1] + 1

      sum += nums[i]
    end

    # Find the smallest missing integer >= sum
    seen = nums.to_set
    x = sum
    x += 1 while seen.include?(x)
    x
  end

  # Length of Longest Subarray With at Most K Frequency
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def max_subarray_length(nums, k)
    freq = Hash.new(0)
    left = 0
    best = 0

    nums.each_with_index do |num, right|
      freq[num] += 1

      # Shrink from the left while this element breaks the "good" condition
      while freq[num] > k
        freq[nums[left]] -= 1
        left += 1
      end

      best = [best, right - left + 1].max
    end

    best
  end

  # 3702. Longest Subsequence With Non-Zero Bitwise XOR
  # @param {Integer[]} nums
  # @return {Integer}
  def longest_subsequence(nums)
    total = nums.reduce(0, :^)

    # If the XOR of the whole array is non-zero, take everything.
    return nums.length if total != 0

    # XOR is zero. If there's at least one non-zero element, drop one
    # to break the cancellation -> length n - 1. Otherwise all zeros -> 0.
    nums.any? { |x| x != 0 } ? nums.length - 1 : 0
  end

  # 2029. Stone Game IX
  # @param {Integer[]} stones
  # @return {Boolean}
  def stone_game_ix(stones)
    # Only remainders mod 3 matter
    cnt = [0, 0, 0]
    stones.each { |s| cnt[s % 3] += 1 }

    c0 = cnt[0]
    c1 = cnt[1]
    c2 = cnt[2]

    # If there are no 1s and no 2s, Alice can't make a legal first move
    # that avoids losing later — she loses.
    return false if c1 == 0 && c2 == 0

    if c0.even?
      # Zeros act as "pass"/parity flips that cancel out in pairs.
      # Alice wins unless both counts are zero (handled) — she wins
      # if there's at least one 1 and one 2.
      c1 >= 1 && c2 >= 1
    else
      # Odd number of zeros effectively swaps whose "turn parity" it is.
      # Alice wins only if the counts differ by more than 2.
      (c1 - c2).abs > 2
    end
  end

  # 1563. Stone Game V
  # @param {Integer[]} stone_value
  # @return {Integer}
  def stone_game_v(stone_value)
    n = stone_value.length
    @f = Array.new(n) { Array.new(n, 0) }
    dfs(stone_value, 0, n - 1)
  end

  def dfs(stone_value, left, right)
    return 0 if left == right
    return @f[left][right] if @f[left][right] != 0

    sum = 0
    (left..right).each { |i| sum += stone_value[i] }

    suml = 0
    (left...right).each do |i|
      suml += stone_value[i]
      sumr = sum - suml

      @f[left][right] = if suml < sumr
                          [@f[left][right], dfs(stone_value, left, i) + suml].max
                        elsif suml > sumr
                          [@f[left][right], dfs(stone_value, i + 1, right) + sumr].max
                        else
                          [
                            @f[left][right],
                            [dfs(stone_value, left, i), dfs(stone_value, i + 1, right)].max + suml
                          ].max
                        end
    end

    @f[left][right]
  end

  # 3471. Find the Largest Almost Missing Integer
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def largest_integer(nums, k)
    n = nums.length
    counts = Hash.new(0)
    nums.each { |x| counts[x] += 1 }

    # k == n: the whole array is the only subarray, so every distinct
    # value appears in exactly one subarray. Answer is the max element.
    return nums.max if k == n

    if k == 1
      # Each element is its own subarray of size 1. A value is "almost
      # missing" iff it occurs exactly once in nums.
      best = -1
      counts.each { |val, c| best = val if c == 1 && val > best }
      return best
    end

    # 1 < k < n: only the first and last elements can appear in exactly
    # one window (the leftmost/rightmost). Any interior value spans at
    # least two windows. Each endpoint qualifies only if it's unique.
    best = -1
    first = nums[0]
    last = nums[n - 1]
    best = first if counts[first] == 1 && first > best
    best = last  if counts[last]  == 1 && last  > best
    best
  end

  # 1386. Cinema Seat Allocation
  # @param {Integer} n
  # @param {Integer[][]} reserved_seats
  # @return {Integer}
  def max_number_of_families(n, reserved_seats)
    # For each row that has any reservation, track which of seats 2..9
    # are taken using a bitmask. Seats 1 and 10 never matter.
    rows = Hash.new(0)
    reserved_seats.each do |row, seat|
      rows[row] |= (1 << seat) if seat >= 2 && seat <= 9
    end

    # Three candidate blocks (bits set for the seats each occupies):
    left   = (1 << 2) | (1 << 3) | (1 << 4) | (1 << 5)  # seats 2-5
    middle = (1 << 4) | (1 << 5) | (1 << 6) | (1 << 7)  # seats 4-7
    right  = (1 << 6) | (1 << 7) | (1 << 8) | (1 << 9)  # seats 6-9

    # Untouched rows can each seat 2 groups (2-5 and 6-9).
    count = (n - rows.size) * 2

    rows.each_value do |mask|
      if (mask & left).zero? && (mask & right).zero?
        count += 2               # both outer blocks fit
      elsif (mask & left).zero? || (mask & middle).zero? || (mask & right).zero?
        count += 1               # exactly one block fits
      end
      # otherwise 0 groups for this row
    end

    count
  end

  # 3069. Distribute Elements Into Two Arrays I
  # @param {Integer[]} nums
  # @return {Integer[]}
  def result_array(nums)
    arr1 = [nums[0]]
    arr2 = [nums[1]]

    (2...nums.length).each do |i|
      if arr1.last > arr2.last
        arr1 << nums[i]
      else
        arr2 << nums[i]
      end
    end

    arr1 + arr2
  end
end
