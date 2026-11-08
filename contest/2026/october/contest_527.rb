class Contest527
  # Find Mismatched Segments Between Two Strings
  # @param {String} s1
  # @param {String} s2
  # @return {String[][]}
  def find_mismatched_segments(s1, s2)
    ans = []
    start = nil

    s1.length.times do |i|
      if s1[i] != s2[i]
        start ||= i
      elsif start
        ans << [s1[start...i], s2[start...i]]
        start = nil
      end
    end

    ans << [s1[start..], s2[start..]] if start

    ans
  end

  # Count Indices Where the Suffix Sort Equals the Target
  # @param {Integer[]} nums
  # @param {Integer[]} target
  # @return {Integer}
  def count_matching_suffix_sorts(nums, target)
    n = nums.size

    # A suffix sorted non-increasing can only match target if target's suffix
    # from that index is already non-increasing; find the first such index.
    start_limit = n - 1
    start_limit -= 1 while start_limit > 0 && target[start_limit - 1] >= target[start_limit]

    # The untouched prefix must match, which holds for every i <= first_diff.
    first_diff = (0...n).find { |i| nums[i] != target[i] } || n

    size = [nums.max, target.max].max + 1
    diff = Array.new(size, 0) # count in nums suffix minus count in target suffix
    nonzero = 0
    ans = 0

    (n - 1).downto(0) do |i|
      a = nums[i]
      before = diff[a]
      diff[a] = before + 1
      nonzero += 1 if before == 0
      nonzero -= 1 if before == -1

      b = target[i]
      before = diff[b]
      diff[b] = before - 1
      nonzero += 1 if before == 0
      nonzero -= 1 if before == 1

      # Equal multisets + non-increasing target suffix => sorting nums[i..] hits target.
      ans += 1 if nonzero.zero? && i <= first_diff && i >= start_limit
    end

    ans
  end

  # Minimum Cost to Make Red Nodes Connected
  # Flipping node u costs the size of u's subtree, so the cost of turning a
  # node blue is sz[u] (when it is red) and the cost of making it red is sz[u]
  # (when it is blue). Any valid non-empty red set is a connected node set with
  # a unique topmost node u; dp it.
  # @param {Integer} n
  # @param {String} colors
  # @param {Integer[][]} edges
  # @return {Integer}
  def min_flip_cost(n, colors, edges)
    adj = Array.new(n) { [] }
    edges.each do |u, v|
      adj[u] << v
      adj[v] << u
    end

    # Root the tree at 0 and record a BFS order plus explicit child lists.
    parent = Array.new(n, -1)
    children = Array.new(n) { [] }
    seen = Array.new(n, false)
    seen[0] = true
    order = [0]
    head = 0
    while head < order.size
      u = order[head]
      head += 1
      adj[u].each do |v|
        next if seen[v]

        seen[v] = true
        parent[v] = u
        children[u] << v
        order << v
      end
    end

    sz = Array.new(n, 1)
    (n - 1).downto(1) do |k|
      u = order[k]
      sz[parent[u]] += sz[u]
    end

    # blue[u] = cost of making all of subtree(u) blue (its red nodes flipped).
    # red[u]  = cost of a connected red set inside subtree(u) that contains u.
    blue = Array.new(n, 0)
    red = Array.new(n, 0)
    (n - 1).downto(0) do |k|
      u = order[k]
      b = colors[u] == "R" ? sz[u] : 0
      add = 0
      best = 0
      children[u].each do |v|
        b += blue[v]
        add += red[v] < blue[v] ? red[v] : blue[v]
      end
      blue[u] = b
      red[u] = (colors[u] == "R" ? 0 : sz[u]) + add
    end

    # Either flip every red node (empty red set), or keep a connected red set
    # whose topmost node is u and flip every red node outside subtree(u).
    ans = blue[0]
    n.times do |u|
      cand = red[u] + blue[0] - blue[u]
      ans = cand if cand < ans
    end
    ans
  end
end
