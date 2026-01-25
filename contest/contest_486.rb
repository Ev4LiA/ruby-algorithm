class Contest486
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_prefix_length(nums)
    n = nums.length
    return 0 if n <= 1

    # Iterate from the end of the array to find the start of the
    # longest strictly increasing suffix.
    i = n - 1
    i -= 1 while i > 0 && nums[i - 1] < nums[i]

    # The value of 'i' is the starting index of the longest
    # strictly increasing suffix. This is also the length of the
    # prefix to be removed.
    i
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer[]}
  def rotate_elements(nums, k)
    non_negatives = []
    non_negative_indices = []

    nums.each_with_index do |num, i|
      if num >= 0
        non_negatives << num
        non_negative_indices << i
      end
    end

    m = non_negatives.length
    return nums if m <= 1

    k_effective = k % m
    rotated_non_negatives = non_negatives.rotate(k_effective)

    non_negative_indices.each_with_index do |original_idx, i|
      nums[original_idx] = rotated_non_negatives[i]
    end

    nums
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {Integer} x
  # @param {Integer} y
  # @param {Integer} z
  # @return {Integer}
  def special_nodes(n, edges, x, y, z)
    adj = Array.new(n) { [] }
    edges.each do |u, v|
      adj[u] << v
      adj[v] << u
    end

    run_bfs = lambda do |start_node|
      distances = Array.new(n, -1)
      queue = [[start_node, 0]]
      distances[start_node] = 0

      head = 0
      while head < queue.length
        curr, dist = queue[head]
        head += 1

        adj[curr].each do |neighbor|
          next unless distances[neighbor] == -1

          distances[neighbor] = dist + 1
          queue << [neighbor, dist + 1]
        end
      end
      distances
    end

    dist_x = run_bfs.call(x)
    dist_y = run_bfs.call(y)
    dist_z = run_bfs.call(z)

    special_count = 0
    (0...n).each do |u|
      dists = [dist_x[u], dist_y[u], dist_z[u]].sort
      a, b, c = dists
      special_count += 1 if (a * a) + (b * b) == c * c
    end

    special_count
  end

  # @param {Integer} n
  # @param {Integer} k
  # @return {Integer}
  def nth_smallest(n, k)
    memo_comb = {}
    combinations = lambda do |n_comb, k_comb|
      return 0 if k_comb < 0 || k_comb > n_comb
      return 1 if k_comb == 0 || k_comb == n_comb
      return memo_comb[[n_comb, k_comb]] if memo_comb.key?([n_comb, k_comb])

      # Use symmetry C(n, k) = C(n, n - k)
      k_comb = n_comb - k_comb if k_comb > n_comb / 2
      res = 1
      (1..k_comb).each do |i|
        res = res * (n_comb - i + 1) / i
      end
      memo_comb[[n_comb, k_comb]] = res
      res
    end

    ans = 0
    rem_k = k
    49.downto(0) do |p|
      break if rem_k == 0

      # How many numbers can be formed using the lower p bits with rem_k ones.
      combs = combinations.call(p, rem_k)

      next unless n > combs

      # The target number is not in the set of numbers with a '0' at bit p.
      # So, the target number must have a '1' at bit p.
      ans |= (1 << p)
      n -= combs
      rem_k -= 1
    end

    # If rem_k > 0 at the end, it means we must use the remaining LSBs.
    # This happens when n was exactly C(p, k) at some point.
    ans |= ((1 << rem_k) - 1) if rem_k > 0

    ans
  end
end
