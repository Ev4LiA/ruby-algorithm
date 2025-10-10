class Contest161
  # @param {Integer[]} nums
  # @return {Integer}
  def split_array(nums)
    n = nums.length
    return nums.sum.abs if n <= 2 # No prime indices (since 0 and 1 are not prime)

    # Sieve of Eratosthenes up to n-1 to mark prime indices
    is_prime = Array.new(n, true)
    is_prime[0] = is_prime[1] = false if n > 1
    limit = Math.sqrt(n - 1).floor
    (2..limit).each do |i|
      next unless is_prime[i]

      (i * i).step(n - 1, i) { |j| is_prime[j] = false }
    end

    sum_a = 0 # elements at prime indices
    sum_b = 0 # remaining elements

    nums.each_with_index do |val, idx|
      if is_prime[idx]
        sum_a += val
      else
        sum_b += val
      end
    end

    (sum_a - sum_b).abs
  end

  # @param {Integer[][]} grid
  # @param {Integer} k
  # @return {Integer}
  def count_islands(grid, k)
    m = grid.length
    return 0 if m.zero?

    n = grid[0].length

    visited = Array.new(m) { Array.new(n, false) }
    dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    res = 0

    (0...m).each do |i|
      (0...n).each do |j|
        next if visited[i][j] || grid[i][j].zero?

        # Start BFS for a new island
        sum = 0
        stack = [[i, j]]
        visited[i][j] = true

        until stack.empty?
          r, c = stack.pop
          sum += grid[r][c]

          dirs.each do |dr, dc|
            nr = r + dr
            nc = c + dc
            next if nr < 0 || nr >= m || nc < 0 || nc >= n
            next if visited[nr][nc] || grid[nr][nc].zero?

            visited[nr][nc] = true
            stack << [nr, nc]
          end
        end

        res += 1 if (sum % k).zero?
      end
    end

    res
  end

  # @param {Integer[][]} edges
  # @param {Boolean[]} online
  # @param {Integer} k
  # @return {Integer}
  def find_max_path_score(edges, online, k)
    n = online.length
    return -1 if n < 2

    max_cost = 0
    adj = Array.new(n) { [] }
    in_deg = Array.new(n, 0)

    edges.each do |u, v, c|
      adj[u] << [v, c]
      in_deg[v] += 1
      max_cost = c if c > max_cost
    end

    # Compute a fixed topological order (Kahn's algorithm)
    topo = []
    queue = []
    (0...n).each { |i| queue << i if in_deg[i].zero? }

    until queue.empty?
      u = queue.shift
      topo << u
      adj[u].each do |v, _|
        in_deg[v] -= 1
        queue << v if in_deg[v].zero?
      end
    end

    return -1 unless topo.length == n # safety, DAG assumed

    inf = 1 << 60

    # Helper to check feasibility for a given threshold w
    feasible = lambda do |w|
      dist = Array.new(n, inf)
      dist[0] = 0

      topo.each do |u|
        next if dist[u] == inf
        next if u != 0 && u != n - 1 && !online[u]

        adj[u].each do |v, c|
          next if c < w
          next if v != n - 1 && !online[v]

          nd = dist[u] + c
          dist[v] = nd if nd < dist[v]
        end
      end

      dist[n - 1] <= k
    end

    lo = 0
    hi = max_cost
    ans = -1

    while lo <= hi
      mid = (lo + hi) / 2
      if feasible.call(mid)
        ans = mid
        lo = mid + 1
      else
        hi = mid - 1
      end
    end

    ans
  end

  # 1948. Delete Duplicate Folders in System
  # @param {String[][]} paths
  # @return {String[][]}
  def delete_duplicate_folder(paths)
    
  end
end
