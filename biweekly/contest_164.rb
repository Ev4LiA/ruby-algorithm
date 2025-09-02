class Contest164
  # @param {Integer} n
  # @return {Integer}
  def get_least_frequent_digit(n)
    counts = Array.new(10, 0)

    if n.zero?
      counts[0] = 1 # n = 0 ⇒ digit 0 appears once
    else
      n.abs.digits.each { |d| counts[d] += 1 }
    end

    min_positive = counts.reject(&:zero?).min # ignore digits that never appear
    counts.index(min_positive)
  end

  # @param {String[]} cards
  # @param {Character} x
  # @return {Integer}
  # Calculates the maximum number of compatible-card pairs that can be removed.
  # A card is a 2-letter string. Two cards are compatible if they differ in
  # exactly one position. Only cards containing the special letter `x` are
  # considered, and each removal earns 1 point.
  #
  # Strategy (constant-time because only 10 letters):
  # 1. Partition cards into three buckets:
  #    a) x_?  – x in first position (array cnt_first[letter])
  #    b) ?_x  – x in second position (cnt_second[letter])
  #    c) x_x  – both positions are x (count both)
  # 2. Within bucket (a) you can pair two cards iff their second letters differ.
  #    Given counts per letter, the maximum pairs is:
  #       min(total/2, total − max_letter_count)
  #    The same formula works for bucket (b).
  # 3. Each remaining x_x card can pair with any remaining unpaired card from
  #    buckets (a) or (b). So add min(both, leftovers) to the answer.
  #
  # Complexity: O(cards.length) time, O(1) extra space.
  def score(cards, x)
    base = "a".ord

    cnt_first  = Array.new(10, 0)
    cnt_second = Array.new(10, 0)
    cnt_both   = 0

    cards.each do |card|
      a = card[0]
      b = card[1]

      next unless a == x || b == x

      if a == x && b == x
        cnt_both += 1
      elsif a == x
        idx = b.ord - base
        cnt_first[idx] += 1
      else
        idx = a.ord - base
        cnt_second[idx] += 1
      end
    end

    calc_min_leftover_and_pairs = lambda do |arr|
      total = arr.sum
      return [0, 0] if total.zero?

      max_same = arr.max
      min_leftover = [(2 * max_same) - total, 0].max
      internal_pairs = (total - min_leftover) / 2
      [min_leftover, internal_pairs]
    end

    l1, p1 = calc_min_leftover_and_pairs.call(cnt_first)
    l2, p2 = calc_min_leftover_and_pairs.call(cnt_second)

    min_leftover = l1 + l2
    internal_pairs = p1 + p2

    total_non_bb = cnt_first.sum + cnt_second.sum
    max_leftover = total_non_bb

    if cnt_both <= min_leftover
      return internal_pairs + cnt_both
    elsif cnt_both >= max_leftover
      return total_non_bb
    else
      need = cnt_both - min_leftover
      sacrifices = (need + 1) / 2
      sacrifices = [sacrifices, internal_pairs].min
      return internal_pairs - sacrifices + cnt_both
    end
  end

  # @param {Integer[][]} grid
  # @return {Integer}
  def unique_paths(grid)
    mod = 1_000_000_007
    m = grid.length
    n = grid[0].length

    # Pre-compute, for every empty cell and for each direction (0 = right, 1 = down),
    # the next empty cell the robot actually lands on, or [-1, -1] if it exits the board.
    nxt_right = Array.new(m) { Array.new(n) }
    nxt_down  = Array.new(m) { Array.new(n) }

    # Memoised DFS – direction 0: right, 1: down
    dfs = lambda do |r, c, dir|
      memo = dir.zero? ? nxt_right : nxt_down
      return memo[r][c] unless memo[r][c].nil?

      # If we are currently on a mirror, we must immediately reflect again before
      # attempting any normal step.
      if grid[r][c] == 1
        if dir.zero? # we entered while moving right → turn down
          nr, nc, d2 = r + 1, c, 1
        else        # entered while moving down → turn right
          nr, nc, d2 = r, c + 1, 0
        end

        if nr >= m || nc >= n
          memo[r][c] = [-1, -1]
          return memo[r][c]
        elsif grid[nr][nc].zero?
          memo[r][c] = [nr, nc]
          return memo[r][c]
        else
          memo[r][c] = dfs.call(nr, nc, d2)
          return memo[r][c]
        end
      end

      # Normal case: current cell is empty – try to move one step directly.
      nr, nc = dir.zero? ? [r, c + 1] : [r + 1, c]

      # Fell outside the board
      if nr >= m || nc >= n
        memo[r][c] = [-1, -1]
        return memo[r][c]
      end

      # Landed on an empty cell directly
      if grid[nr][nc].zero?
        memo[r][c] = [nr, nc]
        return memo[r][c]
      end

      # Hit a mirror ⇒ reflect
      if dir.zero? # moving right, turn down and step below the mirror
        nr2, nc2, d2 = nr + 1, nc, 1
      else         # moving down, turn right and step right of the mirror
        nr2, nc2, d2 = nr, nc + 1, 0
      end

      if nr2 >= m || nc2 >= n
        memo[r][c] = [-1, -1]
      elsif grid[nr2][nc2].zero?
        # Landed on an empty cell after reflection
        memo[r][c] = [nr2, nc2]
      else
        # Still on a mirror – continue following reflections
        memo[r][c] = dfs.call(nr2, nc2, d2)
      end
      memo[r][c]
    end

    # Fill the memo tables for all empty cells
    m.times do |r|
      n.times do |c|
        next unless grid[r][c].zero?
        dfs.call(r, c, 0)
        dfs.call(r, c, 1)
      end
    end

    # DP over empty cells
    dp = Array.new(m) { Array.new(n, 0) }
    dp[0][0] = 1

    m.times do |r|
      n.times do |c|
        next if grid[r][c] == 1 || dp[r][c].zero?

        dest = nxt_right[r][c]
        if dest && dest[0] != -1
          dr, dc = dest
          dp[dr][dc] = (dp[dr][dc] + dp[r][c]) % mod
        end

        dest = nxt_down[r][c]
        if dest && dest[0] != -1
          dr, dc = dest
          dp[dr][dc] = (dp[dr][dc] + dp[r][c]) % mod
        end
      end
    end

    dp[m - 1][n - 1]
  end
end
