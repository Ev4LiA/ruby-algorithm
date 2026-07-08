class July2026
  # 2492. Minimum Score of a Path Between Two Cities
  # @param {Integer} n
  # @param {Integer[][]} roads
  # @return {Integer}
  def min_score(n, roads)
    # Build adjacency list: undirected graph
    graph = Array.new(n + 1) { [] }
    roads.each do |u, v, w|
      graph[u] << [v, w]
      graph[v] << [u, w]
    end

    # BFS/DFS from node 1 to traverse its entire connected component.
    # The answer is the minimum edge weight seen on any edge reachable from 1.
    visited = Array.new(n + 1, false)
    queue = [1]
    visited[1] = true
    min_edge = Float::INFINITY

    until queue.empty?
      node = queue.shift

      graph[node].each do |neighbor, weight|
        min_edge = [min_edge, weight].min

        unless visited[neighbor]
          visited[neighbor] = true
          queue << neighbor
        end
      end
    end

    min_edge
  end

  # 1301. Number of Paths with Max Score
  # @param {String[]} board
  # @return {Integer[]}
  def paths_with_max_score(board)
    n = board.length
    mod = 1_000_000_007

    # dp_score[i][j] = max score to reach (i,j)
    # dp_cnt[i][j]   = number of max-score paths to (i,j)
    neg_inf = -10**15
    dp_score = Array.new(n) { Array.new(n, neg_inf) }
    dp_cnt   = Array.new(n) { Array.new(n, 0) }

    # Start at 'S' (bottom-right)
    dp_score[n - 1][n - 1] = 0
    dp_cnt[n - 1][n - 1]   = 1

    (n - 1).downto(0) do |i|
      (n - 1).downto(0) do |j|
        ch = board[i][j]

        # Skip obstacles
        next if ch == "X"

        # Start cell already initialized
        next if i == n - 1 && j == n - 1

        # Gather candidates from (i+1,j), (i,j+1), (i+1,j+1)
        best_score = neg_inf
        ways = 0

        # from below
        if i + 1 < n && dp_cnt[i + 1][j] > 0
          s = dp_score[i + 1][j]
          if s > best_score
            best_score = s
            ways = dp_cnt[i + 1][j]
          elsif s == best_score
            ways = (ways + dp_cnt[i + 1][j]) % mod
          end
        end

        # from right
        if j + 1 < n && dp_cnt[i][j + 1] > 0
          s = dp_score[i][j + 1]
          if s > best_score
            best_score = s
            ways = dp_cnt[i][j + 1]
          elsif s == best_score
            ways = (ways + dp_cnt[i][j + 1]) % mod
          end
        end

        # from diagonal (down-right)
        if i + 1 < n && j + 1 < n && dp_cnt[i + 1][j + 1] > 0
          s = dp_score[i + 1][j + 1]
          if s > best_score
            best_score = s
            ways = dp_cnt[i + 1][j + 1]
          elsif s == best_score
            ways = (ways + dp_cnt[i + 1][j + 1]) % mod
          end
        end

        # If unreachable, leave as default
        next if ways == 0

        # Cell value: digits add to score; 'E' and 'S' contribute 0
        val =
          if ch >= "0" && ch <= "9"
            ch.ord - "0".ord
          else
            0
          end

        dp_score[i][j] = best_score + val
        dp_cnt[i][j]   = ways % mod
      end
    end

    # Result is at 'E' (0,0)
    if dp_cnt[0][0] == 0
      [0, 0]
    else
      [dp_score[0][0] % mod, dp_cnt[0][0] % mod]
    end
  end

  # 3754. Concatenate Non-Zero Digits and Multiply by Sum I
  # @param {Integer} n
  # @return {Integer}
  def sum_and_multiply(n)
    x = 0 # concatenated non-zero digits
    digit_sum = 0 # sum of digits in x

    # Special-case n == 0: there are no non-zero digits -> x = 0, result = 0
    return 0 if n == 0

    # Collect digits in correct order without converting to string
    digits = []
    while n > 0
      digits << (n % 10)
      n /= 10
    end
    digits.reverse_each do |d|
      next if d == 0

      x = (x * 10) + d
      digit_sum += d
    end

    x * digit_sum
  end

  # 3756. Concatenate Non-Zero Digits and Multiply by Sum II
  # @param {String} s
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def sum_and_multiply(s, queries)
    mod = 1_000_000_007

    n = s.length
    # Collect non-zero digits and their original positions
    nz_pos = []
    nz_dig = []

    s.each_char.with_index do |ch, i|
      next if ch == "0"

      nz_pos << i
      nz_dig << (ch.ord - 48) # '0'.ord = 48
    end

    k = nz_pos.length
    # Edge case: no non-zero digit at all
    return Array.new(queries.length, 0) if k == 0

    # Precompute powers of 10, prefix values, prefix digit sums
    pow10 = Array.new(k + 1, 0)
    pow10[0] = 1
    (1..k).each do |i|
      pow10[i] = (pow10[i - 1] * 10) % mod
    end

    # pref_val[i] = value of concatenation of first i digits nz_dig[0...i]
    # pref_dig[i] = sum of first i digits
    pref_val = Array.new(k + 1, 0)
    pref_dig = Array.new(k + 1, 0)

    (0...k).each do |i|
      d = nz_dig[i]
      pref_val[i + 1] = ((pref_val[i] * 10) + d) % mod
      pref_dig[i + 1] = (pref_dig[i] + d) % mod
    end

    # Helper: lower_bound on nz_pos for >= target
    # returns smallest index i such that nz_pos[i] >= target, or k if none
    lower_bound = lambda do |target|
      lo = 0
      hi = k
      while lo < hi
        mid = (lo + hi) / 2
        if nz_pos[mid] >= target
          hi = mid
        else
          lo = mid + 1
        end
      end
      lo
    end

    # Helper: upper_bound on nz_pos for > target
    # returns smallest index i such that nz_pos[i] > target, or k if none
    upper_bound = lambda do |target|
      lo = 0
      hi = k
      while lo < hi
        mid = (lo + hi) / 2
        if nz_pos[mid] > target
          hi = mid
        else
          lo = mid + 1
        end
      end
      lo
    end

    res = Array.new(queries.length, 0)

    queries.each_with_index do |(l, r), idx|
      # Find range [L, R] in nz_pos s.t. l <= pos <= r
      left_idx  = lower_bound.call(l)
      right_idx = upper_bound.call(r) - 1

      if left_idx > right_idx
        res[idx] = 0
        next
      end

      len = right_idx - left_idx + 1

      # Compute x via prefix difference:
      # x = digits[left_idx..right_idx]
      # x = pref_val[right_idx+1] - pref_val[left_idx] * 10^len
      x = pref_val[right_idx + 1] -
          ((pref_val[left_idx] * pow10[len]) % mod)
      x %= mod
      x += mod if x < 0
      x %= mod

      # Sum of digits in that range
      sum_d = pref_dig[right_idx + 1] - pref_dig[left_idx]
      sum_d %= mod
      sum_d += mod if sum_d < 0
      sum_d %= mod

      res[idx] = (x * sum_d) % mod
    end

    res
  end
end
