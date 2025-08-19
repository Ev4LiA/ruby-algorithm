class Contest163
  # @param {Integer} n
  # @param {Integer} m
  # @param {Integer} k
  # @return {Integer}
  def min_sensors(n, m, k)
    # Each sensor covers a (2k+1) × (2k+1) square
    # To minimize sensors, place them (2k+1) apart
    coverage_size = (2 * k) + 1

    # Calculate how many sensors needed in each dimension
    sensors_rows = (n + coverage_size - 1) / coverage_size
    sensors_cols = (m + coverage_size - 1) / coverage_size

    sensors_rows * sensors_cols
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def perfect_pairs(nums)
    # Count zeros separately – any two zeros form a perfect pair
    zero_cnt = nums.count(0)
    pairs = zero_cnt * (zero_cnt - 1) / 2

    # Work with absolute values of non-zero numbers
    abs_vals = nums.reject(&:zero?).map(&:abs).sort

    n = abs_vals.size
    left = 0
    right = 0

    # Two-pointer sweep: for each left index, extend right while abs[right] ≤ 2*abs[left]
    while left < n
      right = [right, left].max
      right += 1 while right < n && abs_vals[right] <= 2 * abs_vals[left]
      pairs += (right - left - 1) # pairs with current left
      left += 1
    end

    pairs
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @return {Integer}
  def min_cost_graph(n, edges)
    # Build adjacency list with original and reversible edges
    adj = Array.new(n) { [] }
    edges.each do |(u, v, w)|
      adj[u] << [v, w]
      adj[v] << [u, 2 * w]
    end

    # Dijkstra's algorithm
    inf = 1 << 60
    dist = Array.new(n, inf)
    dist[0] = 0

    heap = [[0, 0]] # [cost, node]

    # Helper lambdas for heap operations
    push = lambda do |item|
      heap << item
      i = heap.size - 1
      while i.positive?
        parent = (i - 1) / 2
        break if heap[parent][0] <= heap[i][0]

        heap[parent], heap[i] = heap[i], heap[parent]
        i = parent
      end
    end

    pop = lambda do
      return nil if heap.empty?

      min = heap[0]
      last = heap.pop
      unless heap.empty?
        heap[0] = last
        i = 0
        loop do
          l = (2 * i) + 1
          r = (2 * i) + 2
          smallest = i
          smallest = l if l < heap.size && heap[l][0] < heap[smallest][0]
          smallest = r if r < heap.size && heap[r][0] < heap[smallest][0]
          break if smallest == i

          heap[i], heap[smallest] = heap[smallest], heap[i]
          i = smallest
        end
      end
      min
    end

    until heap.empty?
      cost_u, u = pop.call
      next if cost_u > dist[u]

      adj[u].each do |v, w|
        new_cost = cost_u + w
        next unless new_cost < dist[v]

        dist[v] = new_cost
        push.call([new_cost, v])
      end
    end

    dist[n - 1] == inf ? -1 : dist[n - 1]
  end

  # @param {Integer[][]} grid
  # @param {Integer} k
  # @return {Integer}
  def min_cost(grid, k)
    m = grid.size
    n = grid[0].size
    nodes = m * n

    id = ->(r, c) { (r * n) + c }

    cells = []
    (0...m).each do |i|
      (0...n).each do |j|
        cells << [grid[i][j], id.call(i, j)]
      end
    end
    cells.sort_by!(&:first)

    inf = 1 << 60
    max_t = k
    dist = Array.new(max_t + 1) { Array.new(nodes, inf) }
    dist[0][0] = 0

    ptr = Array.new(max_t + 1, 0)

    heap = [[0, 0, 0]]

    push = lambda do |item|
      heap << item
      i = heap.size - 1
      while i.positive?
        parent = (i - 1) / 2
        break if heap[parent][0] <= heap[i][0]

        heap[parent], heap[i] = heap[i], heap[parent]
        i = parent
      end
    end

    pop = lambda do
      return nil if heap.empty?

      min = heap[0]
      last = heap.pop
      unless heap.empty?
        heap[0] = last
        i = 0
        loop do
          l = (2 * i) + 1
          r = (2 * i) + 2
          smallest = i
          smallest = l if l < heap.size && heap[l][0] < heap[smallest][0]
          smallest = r if r < heap.size && heap[r][0] < heap[smallest][0]
          break if smallest == i

          heap[i], heap[smallest] = heap[smallest], heap[i]
          i = smallest
        end
      end
      min
    end

    while (top = pop.call)
      cost_u, node_u, used = top
      next if cost_u > dist[used][node_u]

      r = node_u / n
      c = node_u % n

      if c + 1 < n
        v_id = id.call(r, c + 1)
        new_cost = cost_u + grid[r][c + 1]
        if new_cost < dist[used][v_id]
          dist[used][v_id] = new_cost
          push.call([new_cost, v_id, used])
        end
      end

      if r + 1 < m
        v_id = id.call(r + 1, c)
        new_cost = cost_u + grid[r + 1][c]
        if new_cost < dist[used][v_id]
          dist[used][v_id] = new_cost
          push.call([new_cost, v_id, used])
        end
      end

      if used < max_t
        curr_val = grid[r][c]
        next_layer = used + 1

        while ptr[next_layer] < cells.size && cells[ptr[next_layer]][0] <= curr_val
          _, target_id = cells[ptr[next_layer]]
          if cost_u < dist[next_layer][target_id]
            dist[next_layer][target_id] = cost_u
            push.call([cost_u, target_id, next_layer])
          end
          ptr[next_layer] += 1
        end
      end
    end

    dest_id = nodes - 1
    ans = dist.map { |d| d[dest_id] }.min
    ans >= inf ? -1 : ans
  end
end
