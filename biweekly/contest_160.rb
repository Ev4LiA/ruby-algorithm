class Contest160
  # @param {Integer} n
  # @return {String}
  def concat_hex36(n)
    hex_part = (n * n).to_s(16).upcase      # n^2 in base-16
    base36_part = (n * n * n).to_s(36).upcase # n^3 in base-36
    hex_part + base36_part
  end

  # @param {Integer} m
  # @param {Integer} n
  # @param {Integer[][]} wait_cost
  # @return {Integer}
  def min_cost(m, n, wait_cost)
    # Edge case: if the grid has only one cell (though constraints rule this out)
    return (1) if m == 1 && n == 1

    # Helper lambda to compute entry cost for cell (i, j)
    entry_cost = ->(i, j) { (i + 1) * (j + 1) }

    # dp[j] will hold the minimum total cost to reach cell (current_row, j)
    dp = Array.new(n)

    # Initialize starting cell (0,0) – only pay its entry cost once
    dp[0] = entry_cost.call(0, 0)

    # Fill the first row (moving only right)
    (1...n).each do |j|
      cost = entry_cost.call(0, j)
      # Add wait cost unless this is the destination cell
      cost += wait_cost[0][j] unless (0 == m - 1 && j == n - 1)
      dp[j] = dp[j - 1] + cost
    end

    # Process the remaining rows
    (1...m).each do |i|
      # First column of current row (moving only down)
      cost = entry_cost.call(i, 0)
      cost += wait_cost[i][0] unless (i == m - 1 && 0 == n - 1)
      dp[0] += cost

      # Remaining columns
      (1...n).each do |j|
        cost = entry_cost.call(i, j)
        cost += wait_cost[i][j] unless (i == m - 1 && j == n - 1)

        dp[j] = [dp[j], dp[j - 1]].min + cost
      end
    end

    dp[n - 1]
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @return {Integer}
  def min_time(n, edges)
    return 0 if n <= 1

    # Build adjacency list: adj[u] = [[v, start, ending], ...]
    adj = Array.new(n) { [] }
    edges.each do |edge|
      u, v, s, e = edge
      adj[u] << [v, s, e]
    end

    inf = (1 << 60)
    dist = Array.new(n, inf)
    dist[0] = 0

    # Simple binary min-heap implementation using an array of [time, node]
    heap = []

    push = lambda do |h, pair|
      h << pair
      idx = h.size - 1
      while idx > 0
        parent = (idx - 1) / 2
        break if h[parent][0] <= h[idx][0]
        h[parent], h[idx] = h[idx], h[parent]
        idx = parent
      end
    end

    pop = lambda do |h|
      return nil if h.empty?
      root = h[0]
      last = h.pop
      unless h.empty?
        h[0] = last
        idx = 0
        loop do
          left = idx * 2 + 1
          right = left + 1
          smallest = idx
          smallest = left if left < h.size && h[left][0] < h[smallest][0]
          smallest = right if right < h.size && h[right][0] < h[smallest][0]
          break if smallest == idx
          h[idx], h[smallest] = h[smallest], h[idx]
          idx = smallest
        end
      end
      root
    end

    push.call(heap, [0, 0])

    until heap.empty?
      current = pop.call(heap)
      break if current.nil?
      time, u = current
      next if time > dist[u]

      # Reached destination with minimal time.
      return time if u == n - 1

      adj[u].each do |v, s, e|
        # If the edge's availability window has already passed, skip.
        next if time > e

        # Earliest departure time respecting the edge window.
        depart = time < s ? s : time
        arrival = depart + 1

        if arrival < dist[v]
          dist[v] = arrival
          push.call(heap, [arrival, v])
        end
      end
    end

    # Impossible to reach destination.
    -1
  end

  # 3440. Reschedule Meetings for Maximum Free Time II
  # @param {Integer} event_time
  # @param {Integer[]} start_time
  # @param {Integer[]} end_time
  # @return {Integer}
  def max_free_time(event_time, start_time, end_time)
    n = start_time.size
    q = Array.new(n)
    t1 = 0
    t2 = 0
    (0...n).each do |i|
      if end_time[i] - start_time[i] <= t1
        q[i] = true
      end

      t1 = [t1, start_time[i] - (i == 0 ? 0 : end_time[i - 1])].max

      if end_time[n - i - 1] - start_time[n - i - 1] <= t2
        q[n - i - 1] = true
      end

      t2 = [t2, (i == 0 ? event_time : strat_time[n - i]) - end_time[n - i - 1]].max
    end

    res = 0

    (0...n).each do |i|
      left = i == 0 ? 0 : end_time[i - 1]
      right = i == n - 1 ? event_time : start_time[i + 1]
      if q[i]
        res = [res, right - left].max
      else
        res = [res, right - left - (end_time[i] - start_time[i])].max
      end
    end

    res
  end
end
