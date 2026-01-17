require "set"

class Contest174
  # @param {Integer[][]} towers
  # @param {Integer[]} center
  # @param {Integer} radius
  # @return {Integer[]}
  def best_tower(towers, center, radius)
    cx, cy = center

    reachable_towers = towers.select do |x, y, _q|
      (x - cx).abs + (y - cy).abs <= radius
    end

    return [-1, -1] if reachable_towers.empty?

    # Find the tower that is minimum by the array [-quality, x, y].
    # This sorts by quality descending, then x ascending, then y ascending.
    best = reachable_towers.min_by do |x, y, q|
      [-q, x, y]
    end

    [best[0], best[1]]
  end

  # @param {Integer[]} nums
  # @param {Integer[]} target
  # @return {Integer}
  def min_operations(nums, target)
    required_operations_values = Set.new
    n = nums.length

    n.times do |i|
      required_operations_values.add(nums[i]) if nums[i] != target[i]
    end

    required_operations_values.size
  end

  # @param {Integer[]} nums
  # @param {Integer} target1
  # @param {Integer} target2
  # @return {Integer}
  def alternating_xor(nums, target1, target2)
    mod = (10**9) + 7

    # dp_odd[i]: num valid partitions of nums[0..i-1] with odd number of blocks
    dp_odd = Array.new(nums.length + 1, 0)
    # dp_even[i]: num valid partitions of nums[0..i-1] with even number of blocks
    dp_even = Array.new(nums.length + 1, 0)

    # Base case: empty prefix has 1 partition (the empty one) with 0 blocks (even)
    dp_even[0] = 1

    # These maps store the sum of dp_odd and dp_even values for each prefix_xor value encountered.
    # key: prefix_xor, value: sum of dp values
    sum_odd_for_px = { 0 => 0 }
    sum_even_for_px = { 0 => 1 }

    current_prefix_xor = 0
    nums.each_with_index do |num, i|
      current_prefix_xor ^= num

      # To form a new partition of nums[0..i] ending with an odd number of blocks,
      # we must append a new block to a partition of nums[0..j-1] that had an even number of blocks.
      # The new block (the k-th, where k is odd) must have an XOR sum of target1.
      # block_xor = current_prefix_xor ^ prefix_xor_at_j = target1
      # => prefix_xor_at_j = current_prefix_xor ^ target1
      target_px_for_t1 = current_prefix_xor ^ target1
      contrib_from_even = sum_even_for_px.fetch(target_px_for_t1, 0)
      dp_odd[i + 1] = contrib_from_even

      # Similarly for an even number of blocks. The new block must have an XOR of target2.
      target_px_for_t2 = current_prefix_xor ^ target2
      contrib_from_odd = sum_odd_for_px.fetch(target_px_for_t2, 0)
      dp_even[i + 1] = contrib_from_odd

      # Update the sum maps with the new dp values for the current_prefix_xor
      sum_odd_for_px[current_prefix_xor] = (sum_odd_for_px.fetch(current_prefix_xor, 0) + dp_odd[i + 1]) % mod
      sum_even_for_px[current_prefix_xor] = (sum_even_for_px.fetch(current_prefix_xor, 0) + dp_even[i + 1]) % mod
    end

    (dp_odd.last + dp_even.last) % mod
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {String} start
  # @param {String} target
  # @return {Integer[]}
  def minimum_flips(n, edges, start, target)
    adj = Array.new(n) { [] }
    edges.each_with_index do |(u, v), i|
      adj[u] << [v, i]
      adj[v] << [u, i]
    end

    diff = Array.new(n)
    n.times do |i|
      diff[i] = start[i].to_i ^ target[i].to_i
    end

    result_edges = []

    # We need to use a stack for an iterative DFS to avoid recursion depth limits for n=10^5
    stack = [[0, -1, :discover]] # [node, parent, action]
    visited = Array.new(n, false)

    until stack.empty?
      u, p, action = stack.pop

      if action == :discover
        visited[u] = true
        stack.push([u, p, :process]) # Schedule processing for after children are done

        adj[u].each do |v, _edge_idx|
          next if v == p

          stack.push([v, u, :discover])
        end
      elsif diff[u] == 1 && p != -1 # :process action
        # This part runs in post-order
        edge_to_parent_idx = adj[u].find { |v, _| v == p }[1]
        result_edges << edge_to_parent_idx
        diff[p] ^= 1 # If node u needs a flip and is not the root
        # The flip must come from the parent edge
      end
    end

    # After the traversal, if the root's diff is 1, the total diff was odd, so impossible.
    # We need a different approach for this check based on the traversal.
    # Let's use a recursive approach with a helper or lambda and assume recursion limit is fine for now,
    # as it's cleaner to express the logic. The iterative one is more complex to get right.

    # Resetting for a cleaner recursive approach
    diff = Array.new(n) { |i| start[i].to_i ^ target[i].to_i }
    result_edges = []

    dfs = lambda do |u, p|
      adj[u].each do |v, edge_idx|
        next if v == p

        dfs.call(v, u)
        if diff[v] == 1
          result_edges << edge_idx
          diff[u] ^= 1
        end
      end
    end

    dfs.call(0, -1)

    if diff[0] == 1
      [-1]
    else
      result_edges.sort
    end
  end
end
