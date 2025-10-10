class Contest454
  MOD = 10**9 + 7

  # @param {String} caption
  # @return {String}
  def generate_tag(caption)
    words = caption.split.map do |word|
      word.gsub(/[^a-zA-Z]/, '')
    end.reject(&:empty?)

    camel_case = words.map.with_index do |word, index|
      if index == 0
        word.downcase
      else
        word.capitalize
      end
    end.join('')

    tag = '#' + camel_case
    tag.length > 100 ? tag[0...100] : tag
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def special_triplets(nums)
    n = nums.length
    count = 0

    # Count total frequency of each element
    total_freq = Hash.new(0)
    nums.each { |num| total_freq[num] += 1 }

    # Track frequency of elements to the left of current position
    left_freq = Hash.new(0)

    # For each possible middle index j
    (0...n).each do |j|
      target = nums[j] * 2

      # Calculate frequency to the right: total - left - current
      right_freq = total_freq[target] - left_freq[target]
      right_freq -= 1 if nums[j] == target  # Exclude current element

      # Add triplets with j as middle
      count = (count + left_freq[target] * right_freq) % MOD

      # Update left frequency for next iteration
      left_freq[nums[j]] += 1
    end

    count
  end

  # @param {Integer[]} nums
  # @param {Integer} m
  # @return {Integer}
  def maximum_product(nums, m)
    n = nums.length

    # Special case: if m == 1, first and last are the same element
    if m == 1
      return nums.map { |x| x * x }.max
    end

    # Build suffix maximum and minimum arrays
    suffix_max = Array.new(n)
    suffix_min = Array.new(n)

    suffix_max[n-1] = nums[n-1]
    suffix_min[n-1] = nums[n-1]

    (n-2).downto(0) do |i|
      suffix_max[i] = [nums[i], suffix_max[i+1]].max
      suffix_min[i] = [nums[i], suffix_min[i+1]].min
    end

    max_product = -Float::INFINITY

    # For each valid starting position
    (0..n-m).each do |i|
      # The last element must be at position >= i + m - 1
      last_pos = i + m - 1

      # Try both maximum and minimum from the valid suffix
      # (since negative * negative can be larger than positive * positive)
      product1 = nums[i] * suffix_max[last_pos]
      product2 = nums[i] * suffix_min[last_pos]

      max_product = [max_product, product1, product2].max
    end

    max_product
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def find_median(n, edges, queries)
    log = (Math.log2(n) + 1).to_i
    graph = Array.new(n) { [] }
    parent = Array.new(n) { Array.new(log, -1) }
    weight = Array.new(n) { Array.new(log, 0) }
    depth = Array.new(n, 0)

    edges.each do |u, v, w|
      graph[u] << [v, w]
      graph[v] << [u, w]
    end

    dfs(0, -1, 0, graph, parent, weight, depth)
    build_lca(n, log, parent, weight)

    results = []
    queries.each do |u, v|
      results << find_weighted_median(u, v, log, parent, weight, depth)
    end

    results
  end

  private

  def dfs(node, par, d, graph, parent, weight, depth)
    parent[node][0] = par
    depth[node] = d

    graph[node].each do |child, w|
      if child != par
        weight[child][0] = w
        dfs(child, node, d + 1, graph, parent, weight, depth)
      end
    end
  end

  def build_lca(n, log, parent, weight)
    (1...log).each do |j|
      (0...n).each do |i|
        if parent[i][j-1] != -1
          parent[i][j] = parent[parent[i][j-1]][j-1]
          weight[i][j] = weight[i][j-1] + weight[parent[i][j-1]][j-1]
        end
      end
    end
  end

  def find_lca(u, v, log, parent, depth)
    u, v = v, u if depth[u] < depth[v]

    diff = depth[u] - depth[v]
    (0...log).each do |i|
      if (diff & (1 << i)) != 0
        u = parent[u][i]
      end
    end

    return u if u == v

    (log-1).downto(0) do |i|
      if parent[u][i] != parent[v][i]
        u = parent[u][i]
        v = parent[v][i]
      end
    end

    parent[u][0]
  end

  def get_path_weight(node, ancestor, log, parent, weight, depth)
    total_weight = 0
    diff = depth[node] - depth[ancestor]

    (0...log).each do |i|
      if (diff & (1 << i)) != 0
        total_weight += weight[node][i]
        node = parent[node][i]
      end
    end

    total_weight
  end

  def find_weighted_median(u, v, log, parent, weight, depth)
    return u if u == v

    lca = find_lca(u, v, log, parent, depth)
    total_weight = get_path_weight(u, lca, log, parent, weight, depth) +
                   get_path_weight(v, lca, log, parent, weight, depth)
    target_weight = total_weight / 2.0

    cum_weight = 0
    current = u

    while current != lca
      next_parent = parent[current][0]
      edge_weight = weight[current][0]

      if cum_weight + edge_weight >= target_weight
        return next_parent
      end

      cum_weight += edge_weight
      current = next_parent
    end

    path_to_v = []
    temp = v
    while temp != lca
      path_to_v << temp
      temp = parent[temp][0]
    end

    path_to_v.reverse!

    path_to_v.each do |node|
      edge_weight = weight[node][0]
      if cum_weight + edge_weight >= target_weight
        return node
      end
      cum_weight += edge_weight
    end

    v
  end

  def solve
    # Test the special_triplets examples
    puts "Special Triplets:"
    puts special_triplets([6,3,6])  # Expected: 1
    puts special_triplets([0,1,0,0])  # Expected: 1
    puts special_triplets([8,4,2,8,4])  # Expected: 2

    puts "\nMaximum Product:"
    # Test the maximum_product examples
    puts maximum_product([-1,-9,2,3,-2,-3,1], 1)  # Expected: 81
    puts maximum_product([1,3,-5,5,6,-4], 3)  # Expected: 20
    puts maximum_product([2,-1,2,-6,5,2,-5,7], 2)  # Expected: 35

    puts "\nFind Median:"
    # Test the find_median examples
    puts find_median(2, [[0,1,7]], [[1,0],[0,1]]).inspect  # Expected: [0,1]
    puts find_median(3, [[0,1,2],[2,0,4]], [[0,1],[2,0],[1,2]]).inspect  # Expected: [1,0,2]
    puts find_median(5, [[0,1,2],[0,2,5],[1,3,1],[2,4,3]], [[3,4],[1,2]]).inspect  # Expected: [2,2]

    # Test the failing case
    puts find_median(2, [[0,1,2]], [[1,1]]).inspect  # Expected: [0] (round-trip 1->0->1, median at weight 2)
  end
end

if __FILE__ == $0
  contest = Contest454.new
  contest.solve
end
