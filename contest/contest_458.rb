class Contest458
  # @param {String} s
  # @return {String}
  def process_str(s)
    result = ""

    s.each_char do |ch|
      case ch
      when 'a'..'z'
        result << ch
      when '*'
        result.chop! unless result.empty?
      when '#'
        result << result.dup
      when '%'
        result.reverse!
      end
    end

    result
  end

  alias build_final_string process_str

  # @param {Integer} n
# @param {Integer[][]} edges
# @param {Integer} k
# @return {Integer}
  def min_cost(n, edges, k)
    # If we are allowed as many components as nodes, we can remove all edges
    return 0 if k >= n

    # Sort edges by weight (ascending)
    edges.sort_by! { |e| e[2] }

    # ----- Disjoint Set Union (Union-Find) -----
    parent = Array.new(n) { |i| i }
    rank   = Array.new(n, 0)

    find = lambda do |x|
      while parent[x] != x
        parent[x] = parent[parent[x]]
        x = parent[x]
      end
      x
    end

    components = n
    answer = 0

    edges.each do |u, v, w|
      break if components <= k

      ru = find.call(u)
      rv = find.call(v)
      next if ru == rv  # already connected

      # Union by rank
      if rank[ru] < rank[rv]
        parent[ru] = rv
      elsif rank[ru] > rank[rv]
        parent[rv] = ru
      else
        parent[rv] = ru
        rank[ru] += 1
      end

      components -= 1
      answer = w  # largest weight included so far
    end

    answer
  end

  # @param {String} s
  # @param {Integer} k
  # @return {Character}
  def process_str(s, k)
    n = s.length
    lengths = Array.new(n, 0)
    len = 0

    # Forward pass to compute length after each operation
    s.each_char.with_index do |ch, idx|
      case ch
      when 'a'..'z'
        len += 1
      when '*'
        len -= 1 if len > 0
      when '#'
        len *= 2
      when '%'
        # length unchanged
      end
      # Cap length at k to avoid huge growth beyond what we need for index lookup
      # but we also need actual length comparisons; k can be up to 1e15, so store full len (Ruby bignum handles).
      lengths[idx] = len
      # Early exit if length already exceeds 1e15 (problem guarantee) but Ruby can handle big integers, so skip.
    end

    final_len = len
    return '.' if k >= final_len

    # Backward pass to resolve k-th character
    (n - 1).downto(0) do |idx|
      ch = s[idx]
      len_after = lengths[idx]
      len_before = idx.zero? ? 0 : lengths[idx - 1]

      case ch
      when 'a'..'z'
        # This operation appended one character at position len_after - 1
        if k == len_after - 1
          return ch
        end
        # else the character lies in the previous part; nothing to adjust
      when '*'
        # If a character was removed (len_before = len_after + 1)
        if len_before == len_after + 1
          # Removed char was at index len_after; remaining indices unchanged
          # If k >= len_after, it referred to removed char but k < final_len <= len_after; impossible.
        end
        # k unchanged
      when '#'
        # Result duplicated: first half indexes 0..len_before-1, second half len_before..2*len_before-1
        if k >= len_before
          k -= len_before
        end
      when '%'
        # Reverse: position k maps to len_before - 1 - k (since lengths equal)
        k = len_before - 1 - k if len_before > 0
      end
    end

    # Should not reach here
    '.'
  end
end
