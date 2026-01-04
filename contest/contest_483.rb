class Contest483
  # @param {String} s
  # @return {String}
  def largest_even(s)
    n = s.length
    (n - 1).downto(0).each do |i|
      return s[0..i] if s[i].to_i.even?
    end
    ""
  end

  # ✦ I understand. I need to find all unique 4x4 "word squares" from a given list of
  # distinct 4-letter words.

  # Given the small constraint on the number of words (up to 15), I can iterate through
  # all possible combinations of four distinct words for the top, left, right, and
  # bottom positions and check if they satisfy the corner constraints.

  # To make this more efficient than a naive O(N^4) brute-force search, I'll use a
  # pre-processing step:

  #  1. Pre-processing: I'll create two hashmaps to group the words.
  #      * words_by_start_char: Maps a starting character to a list of words beginning
  #        with that character.
  #      * words_by_start_end_char: Maps a [start_char, end_char] pair to a list of
  #        words with that specific start and end character.

  #  2. Iterative Search: I will then iterate:
  #      * Pick a top word.
  #      * Using words_by_start_char, get a list of candidates for the left word (which
  #        must start with top[0]) and the right word (which must start with top[3]).
  #      * For each valid (top, left, right) combination, I can instantly find
  #        candidates for the bottom word using words_by_start_end_char (it must start
  #        with left[3] and end with right[3]).
  #      * For each valid set of four distinct words, I'll add it to a results list.

  #  3. Sorting: Finally, I'll sort the list of valid squares lexicographically as
  #     required.

  # @param {String[]} words
  # @return {String[][]}
  def word_squares(words)
    words_by_start_char = Hash.new { |h, k| h[k] = [] }
    words_by_start_end_char = Hash.new { |h, k| h[k] = [] }
    words.each do |word|
      words_by_start_char[word[0]] << word
      words_by_start_end_char[[word[0], word[3]]] << word
    end

    result = []
    words.each do |top|
      # Candidates for left must start with top[0]
      left_candidates = words_by_start_char[top[0]]
      # Candidates for right must start with top[3]
      right_candidates = words_by_start_char[top[3]]

      left_candidates.each do |left|
        next if left == top

        right_candidates.each do |right|
          next if right == top || right == left

          # Candidates for bottom must start with left[3] and end with right[3]
          bottom_candidates = words_by_start_end_char[[left[3], right[3]]]

          bottom_candidates.each do |bottom|
            next if bottom == top || bottom == left || bottom == right

            # All constraints are met by construction
            result << [top, left, right, bottom]
          end
        end
      end
    end

    result.sort
  end

  # This is a fascinating optimization problem. The key is to analyze the costs of
  # resolving different types of mismatches between the strings. The fact that we can
  # swap characters within s or t means we only need to consider the counts of
  # mismatches, not their specific positions.

  # Let's categorize the indices i where s[i] != t[i] into two groups:
  #  * Type A: s[i] = '0', t[i] = '1'
  #  * Type B: s[i] = '1', t[i] = '0'

  # Let count_a and count_b be the number of mismatches of Type A and Type B,
  # respectively.

  # My strategy will be to calculate the minimum cost based on these counts and the
  # costs of the three operations:

  #  1. Resolving a pair of (Type A, Type B) mismatches:
  #     We can take one mismatch of Type A and one of Type B. For example, s[i]=0,
  # t[i]=1 and s[j]=1, t[j]=0.
  #      * Option 1: Swap. Swap s[i] and s[j]. Now s[i]=1, t[i]=1 (match) and s[j]=0,
  #        t[j]=0 (match). This resolves both mismatches for a single swapCost.
  #      * Option 2: Flip. Fix them independently by flipping. For the first mismatch,
  #        flip s[i] (0->1). For the second, flip s[j] (1->0). This costs 2 * flipCost.
  #      * The minimum cost to resolve a pair is min(swapCost, 2 * flipCost).

  #  2. Resolving a pair of same-type mismatches:
  #     Suppose we have two Type A mismatches: s[i]=0, t[i]=1 and s[j]=0, t[j]=1.
  #      * Option 1: Flip. Flip s[i] and s[j]. The cost is 2 * flipCost.
  #      * Option 2: Cross Swap + Swap. Perform a crossCost operation on s[i] and t[i].
  #        This turns the mismatch at i into Type B (s[i]=1, t[i]=0). Now we have a
  #        pair of (Type A, Type B) at indices j and i. We can resolve this new pair
  #        for swapCost. The total cost is crossCost + swapCost.
  #      * The minimum cost to resolve a pair of same-type mismatches is min(2 *
  #        flipCost, swapCost + crossCost).

  #  3. Final Calculation:
  #      * We have min(count_a, count_b) pairs of (Type A, Type B). I'll calculate the
  #        cost for these.
  #      * We are left with |count_a - count_b| mismatches of the same type. I'll group
  #        these into pairs and calculate their cost using the logic from step 2.
  #      * If there's one single mismatch left over, it must be resolved with a
  #        flipCost.

  # @param {String} s
  # @param {String} t
  # @param {Integer} flip_cost
  # @param {Integer} swap_cost
  # @param {Integer} cross_cost
  # @return {Integer}
  def minimum_cost(s, t, flip_cost, swap_cost, cross_cost)
    count_a = 0 # s[i]=0, t[i]=1
    count_b = 0 # s[i]=1, t[i]=0

    (0...s.length).each do |i|
      if s[i] != t[i]
        if s[i] == "0"
          count_a += 1
        else
          count_b += 1
        end
      end
    end

    k_min = [count_a, count_b].min
    k_max = [count_a, count_b].max
    diff = k_max - k_min

    # Cost to resolve pairs of (Type A, Type B)
    cost1 = k_min * [swap_cost, 2 * flip_cost].min

    # Cost to resolve pairs of same-type mismatches
    cost2 = (diff / 2) * [2 * flip_cost, swap_cost + cross_cost].min

    # Cost for any single leftover mismatch
    cost3 = (diff % 2) * flip_cost

    cost1 + cost2 + cost3
  end
end
