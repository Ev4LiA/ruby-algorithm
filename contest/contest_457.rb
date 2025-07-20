class Contest457
  # @param {String[]} code
  # @param {String[]} business_line
  # @param {Boolean[]} is_active
  # @return {String[]}
  def validate_coupons(code, business_line, is_active)
    allowed_lines = %w[electronics grocery pharmacy restaurant]

    # Collect valid coupons into buckets according to their business line
    buckets = Hash.new { |h, k| h[k] = [] }

    n = code.length
    (0...n).each do |i|
      # All three conditions must be true to consider a coupon valid
      next unless is_active[i]
      next unless allowed_lines.include?(business_line[i])
      cur_code = code[i]
      # Code must be non-empty and match the allowed character set (alnum + underscore)
      next if cur_code.nil? || cur_code.empty? || cur_code !~ /\A[A-Za-z0-9_]+\z/

      buckets[business_line[i]] << cur_code
    end

    # Build the final result following the specified ordering rules
    result = []
    allowed_lines.each do |line|
      next unless buckets.key?(line)
      result.concat(buckets[line].sort)
    end

    result
  end

  # @param {Integer} c
  # @param {Integer[][]} connections
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def process_queries(c, connections, queries)
    # ----- Build connected components using Union-Find (DSU) -----
    parent = Array.new(c + 1) { |i| i }

    # Iterative find with path compression
    find = lambda do |x|
      while parent[x] != x
        parent[x] = parent[parent[x]]
        x = parent[x]
      end
      x
    end

    # Union operation
    connections.each do |u, v|
      ru = find.call(u)
      rv = find.call(v)
      parent[ru] = rv if ru != rv
    end

    # ----- Group stations by component and prepare sorted arrays -----
    comp_nodes = Hash.new { |h, k| h[k] = [] }
    (1..c).each do |id|
      root = find.call(id)
      comp_nodes[root] << id
    end

    # Sort node lists so the minimum online id is at the front
    comp_nodes.each_value(&:sort!)

    # Pointer to the first candidate index in each component's node list
    comp_ptr = Hash.new(0)

    # Track online/offline status; true ⇒ offline
    offline = Array.new(c + 1, false)

    results = []

    queries.each do |type, x|
      if type == 1
        if !offline[x]
          # Station x is online; it resolves the maintenance check itself.
          results << x
          next
        end

        root = find.call(x)
        nodes = comp_nodes[root]
        ptr   = comp_ptr[root]

        # Advance pointer while current node is offline
        while ptr < nodes.length && offline[nodes[ptr]]
          ptr += 1
        end
        comp_ptr[root] = ptr

        if ptr == nodes.length
          results << -1
        else
          results << nodes[ptr]
        end
      else # type == 2 => station x goes offline
        offline[x] = true
      end
    end

    results
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {Integer} k
  # @return {Integer}
  def min_time(n, edges, k)
    # ----- Disjoint Set Union (Union-Find) helpers -----
    parent = Array.new(n) { |i| i }
    rank   = Array.new(n, 0)

    find = lambda do |x|
      while parent[x] != x
        parent[x] = parent[parent[x]]
        x = parent[x]
      end
      x
    end

    union = lambda do |a, b|
      ra = find.call(a)
      rb = find.call(b)
      return false if ra == rb

      # Union by rank
      if rank[ra] < rank[rb]
        parent[ra] = rb
      elsif rank[ra] > rank[rb]
        parent[rb] = ra
      else
        parent[rb] = ra
        rank[ra] += 1
      end
      true
    end

    # Sort edges by time descending so we can add them back in reverse-time order
    sorted_edges = edges.sort_by { |e| -e[2] }

    components = n
    answer = 0 # default when we never drop below k components

    sorted_edges.each do |u, v, t|
      break if components < k # already below threshold; earliest time found
      if union.call(u, v)
        components -= 1
        answer = t if components < k
      end
    end

    # If we never fell below k components, the minimum time is 0
    components < k ? answer : 0
  end
end
