class Contest455
  # @param {Integer[]} nums
  # @return {Boolean}
  def check_prime_frequency(nums)
    # Count the frequency of each number
    counts = Hash.new(0)
    nums.each { |n| counts[n] += 1 }

    # The largest frequency determines how far we need to sieve
    max_freq = counts.values.max

    # If the maximum frequency is 1 or less, no prime frequency is possible
    return false if max_freq <= 1

    # Build a sieve of Eratosthenes up to max_freq to identify primes
    prime_numbers = Array.new(max_freq + 1, true)
    prime_numbers[0] = prime_numbers[1] = false
    (2..Math.sqrt(max_freq).floor).each do |i|
      next unless prime_numbers[i]
      (i * i).step(max_freq, i) { |j| prime_numbers[j] = false }
    end

    # Check if any element's frequency is prime
    counts.values.any? { |cnt| prime_numbers[cnt] }
  end


  # @param {Integer[]} num_ways
  # @return {Integer[]]}
  def find_coins(num_ways)
    n = num_ways.length

    # dp[a] will hold the number of ways to form amount 'a' using the denominations found so far
    dp = Array.new(n + 1, 0)
    dp[0] = 1

    coins = []

    (1..n).each do |amount|
      target = num_ways[amount - 1] # because Ruby arrays are 0-indexed

      # If current ways already exceed the target, it's impossible
      return [] if dp[amount] > target

      if dp[amount] < target
        diff = target - dp[amount]

        # Adding a single new coin of value 'amount' increases dp[amount] by exactly 1 (dp[0])
        # Hence diff must be 1, otherwise it's impossible to match the target
        return [] unless diff == 1

        # Record the new coin denomination
        coins << amount

        # Update dp for all future amounts to reflect this new coin
        (amount..n).each do |a|
          dp[a] += dp[a - amount]
        end

        # After updating, dp[amount] should exactly match target. Double-check to be safe.
        return [] unless dp[amount] == target
      end
    end

    coins
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {Integer[]} cost
  # @return {Integer}
  def min_increase(n, edges, cost)
    # Build adjacency list for the tree
    adj = Array.new(n) { [] }
    edges.each do |u, v|
      adj[u] << v
      adj[v] << u
    end

    parent = Array.new(n, -1)

    # Post-order traversal using an explicit stack to avoid deep recursion
    order = []                    # nodes in the order they should be processed (children before parent)
    stack = [[0, false]]          # [node, visited_flag]
    parent[0] = nil

    until stack.empty?
      node, visited = stack.pop
      if visited
        order << node             # all children already pushed ⇒ process later
      else
        stack << [node, true]
        adj[node].each do |nbr|
          next if nbr == parent[node]
          parent[nbr] = node
          stack << [nbr, false]
        end
      end
    end

    path_sum = Array.new(n, 0)    # maximum root-to-leaf sum within the subtree rooted at node
    mods     = Array.new(n, 0)    # minimal nodes increased inside that subtree

    order.each do |u|
      children = adj[u].reject { |v| v == parent[u] }

      if children.empty?          # leaf
        path_sum[u] = cost[u]
        mods[u]     = 0
      else
        # Gather child path sums and child modification counts
        max_child_sum = children.map { |v| path_sum[v] }.max

        # Nodes that need a direct increase to equalise their subtree sums
        additional = 0
        children.each do |v|
          additional += 1 if path_sum[v] < max_child_sum
        end

        # Total modifications in this subtree
        child_mod_total = children.inject(0) { |s, v| s + mods[v] }
        mods[u] = child_mod_total + additional

        # Resulting path sum for this node's subtree
        path_sum[u] = cost[u] + max_child_sum
      end
    end

    mods[0]
  end


  # @param {Integer} n number of individuals
  # @param {Integer} k boat capacity
  # @param {Integer} m number of environmental stages
  # @param {Integer[]} time time[i] is rowing strength (minutes in neutral conditions)
  # @param {Float[]} mul stage multipliers (length m)
  # @return {Float} minimum total time to transport everyone, or -1.0 if impossible
  # Time complexity: O(m * 2^n * (n choose <=k + n)) ≈ O(2^n * n^k) for small constants (n≤12,k≤5)
  def min_time(n, k, m, time, mul)
    full_mask = (1 << n) - 1

    # visited[mask][side][stage] = minimal time to reach state (mask, side, stage)
    visited = Array.new(1 << n) { Array.new(2) { Array.new(m, Float::INFINITY) } }

    # Priority queue implemented with Ruby's Array as binary heap of [total_time, mask, side, stage]
    heap = []

    # Helper methods for heap operations
    def push_heap(heap, item)
      heap << item
      idx = heap.length - 1
      while idx > 0
        parent = (idx - 1) / 2
        break if heap[parent][0] <= heap[idx][0]
        heap[parent], heap[idx] = heap[idx], heap[parent]
        idx = parent
      end
    end

    def pop_heap(heap)
      return nil if heap.empty?
      root = heap[0]
      last = heap.pop
      if !heap.empty?
        heap[0] = last
        idx = 0
        len = heap.length
        loop do
          l = idx * 2 + 1
          r = l + 1
          break if l >= len
          child = (r < len && heap[r][0] < heap[l][0]) ? r : l
          break if heap[idx][0] <= heap[child][0]
          heap[idx], heap[child] = heap[child], heap[idx]
          idx = child
        end
      end
      root
    end

    # Initial state: no one crossed, boat on base side (0), stage 0, time 0.0
    visited[0][0][0] = 0.0
    push_heap(heap, [0.0, 0, 0, 0])

    while (node = pop_heap(heap))
      curr_time, mask, side, stage = node
      # Skip if we already have better time recorded
      next if curr_time > visited[mask][side][stage] + 1e-9

      # Goal: everyone at destination and boat also at destination side (1)
      return curr_time if mask == full_mask && side == 1

      if side == 0
        # Boat at base, choose group of 1..k people from those not yet crossed
        remaining_indices = []
        (0...n).each { |i| remaining_indices << i if mask & (1 << i) == 0 }
        next if remaining_indices.empty? # should not happen unless k=0

        (1..[k, remaining_indices.size].min).each do |size|
          remaining_indices.combination(size) do |group|
            group_mask = 0
            max_time = 0
            group.each do |idx|
              group_mask |= (1 << idx)
              max_time = time[idx] if time[idx] > max_time
            end

            crossing = max_time * mul[stage]
            next_stage = (stage + crossing.floor) % m
            new_time = curr_time + crossing
            new_mask = mask | group_mask
            new_side = 1

            if new_time < visited[new_mask][new_side][next_stage] - 1e-9
              visited[new_mask][new_side][next_stage] = new_time
              push_heap(heap, [new_time, new_mask, new_side, next_stage])
            end
          end
        end
      else
        # Boat at destination side, if not everyone delivered, choose a returner
        break if mask == 0 # safety; should not happen
        returners = []
        (0...n).each { |i| returners << i if mask & (1 << i) != 0 }

        returners.each do |idx|
          return_time = time[idx] * mul[stage]
          next_stage = (stage + return_time.floor) % m
          new_time = curr_time + return_time
          new_mask = mask & ~(1 << idx)
          new_side = 0
          if new_time < visited[new_mask][new_side][next_stage] - 1e-9
            visited[new_mask][new_side][next_stage] = new_time
            push_heap(heap, [new_time, new_mask, new_side, next_stage])
          end
        end
      end
    end

    -1.0 # unreachable
  end
end
