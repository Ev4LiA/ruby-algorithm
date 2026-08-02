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
end
