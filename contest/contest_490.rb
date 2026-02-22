class Contest490
  # @param {Integer[]} nums
  # @return {Integer}
  def score_difference(nums)
    player1_score = 0
    player2_score = 0
    active_player = 1 # 1 for player 1, 2 for player 2

    nums.each_with_index do |points, i|
      # Rule 1: If nums[i] is odd, the active and inactive players swap roles.
      if points.odd?
        active_player = 3 - active_player # Swaps between 1 and 2
      end

      # Rule 2: In every 6th game (that is, game indices 5, 11, 17, ...), the active and inactive players swap roles.
      if (i + 1) % 6 == 0
        active_player = 3 - active_player # Swaps between 1 and 2
      end

      # The active player plays the ith game and gains nums[i] points.
      if active_player == 1
        player1_score += points
      else
        player2_score += points
      end
    end

    player1_score - player2_score
  end

  FACTORIALS = [1, 1, 2, 6, 24, 120, 720, 5040, 40_320, 362_880].freeze

  # @param {Integer} n
  # @return {Boolean}
  def is_digitorial_permutation(n)
    digits_n = n.to_s.chars.map(&:to_i)

    factorial_sum = digits_n.sum { |digit| FACTORIALS[digit] }

    digits_sum = factorial_sum.to_s.chars.map(&:to_i)

    digits_n.sort == digits_sum.sort
  end

  # @param {String} s
  # @param {String} t
  # @return {String}
  def maximum_xor_value(s, t)
    ones_in_t = t.count("1")
    zeros_in_t = t.count("0")
    result_str = ""

    s.each_char do |s_char|
      if s_char == "1"
        # To get a '1' in the result, we need to XOR with '0'.
        if zeros_in_t > 0
          result_str += "1"
          zeros_in_t -= 1
        else
          # No '0's left in t, must use a '1'.
          result_str += "0"
          ones_in_t -= 1
        end
      elsif ones_in_t > 0 # s_char == '0'
        # To get a '1' in the result, we need to XOR with '1'.
        result_str += "1"
        ones_in_t -= 1
      else
        # No '1's left in t, must use a '0'.
        result_str += "0"
        zeros_in_t -= 1
      end
    end

    result_str
  end
end
