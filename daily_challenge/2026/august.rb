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
end
