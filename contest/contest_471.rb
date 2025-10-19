class Contest471
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def sum_divisible_by_k(nums, k)
    count = nums.tally
    sum = 0
    count.each do |num, cnt|
      sum += num * cnt if (cnt % k).zero?
    end

    sum
  end

  # @param {String} s
  # @return {Integer}
  def longest_balanced(s)
    n = s.length
    max_len = 0

    is_balanced = lambda do |freq|
      common = 0
      freq.each do |f|
        if f.positive?
          common = f if common.zero?
          return false if f != common
        end
      end
      true
    end

    (0...n).each do |i|
      freq = Array.new(26, 0)
      (i...n).each do |j|
        freq[s[j].ord - "a".ord] += 1
        max_len = [max_len, j - i + 1].max if is_balanced.call(freq)
      end
    end
    ans
  end

  # @param {String} s
  # @return {Integer}
  def longest_balanced_ii(s)
    n = s.length
    return n if n <= 1

    # Helper: longest run of identical chars (single-letter balanced)
    single = 1
    cur = 1
    (1...n).each do |i|
      if s[i] == s[i - 1]
        cur += 1
      else
        single = cur if cur > single
        cur = 1
      end
    end
    single = cur if cur > single

    res = single

    # Case 1: all three letters present and equal counts
    ca = cb = cc = 0
    seen = { [0, 0] => -1 }
    (0...n).each do |i|
      case s[i]
      when "a"
        ca += 1
      when "b"
        cb += 1
      else
        cc += 1
      end

      key = [ca - cb, ca - cc]
      if seen.key?(key)
        len = i - seen[key]
        res = len if len > res
      else
        seen[key] = i
      end
    end

    # Case 2: exactly two letters present and equal counts
    pairs = [%w[a b c], %w[a c b], %w[b c a]]
    pairs.each do |x, y, z|
      diff = 0
      last_other = -1
      pos = { 0 => -1 }

      (0...n).each do |i|
        ch = s[i]
        if ch == z
          # segment break
          diff = 0
          last_other = i
          pos = { 0 => i }
          next
        end

        diff += 1 if ch == x
        diff -= 1 if ch == y

        if pos.key?(diff)
          len = i - pos[diff]
          res = len if len > res
        else
          pos[diff] = i
        end
      end
    end

    res
  end

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {Integer[]} nums
  # @return {Integer}
  def sum_of_ancestors(n, edges, nums)
    return 0 if n <= 1

    # 1. build adjacency
    adj = Array.new(n) { [] }
    edges.each do |u, v|
      adj[u] << v
      adj[v] << u
    end

    # 2. precompute square-free kernel of each number
    max_val = nums.max
    spf = (0..max_val).to_a
    (2..Math.sqrt(max_val).to_i).each do |i|
      next if spf[i] != i

      (i * i).step(max_val, i) { |j| spf[j] = i if spf[j] == j }
    end

    sf = Array.new(n)
    (0...n).each do |idx|
      x = nums[idx]
      kernel = 1
      while x > 1
        p = spf[x]
        cnt = 0
        while x % p == 0
          x /= p
          cnt ^= 1 # only parity matters
        end
        kernel *= p if cnt == 1
      end
      sf[idx] = kernel
    end

    # 3. DFS iterative keeping count of kernels on path
    total = 0
    counter = Hash.new(0)
    stack = [[0, -1, 0]] # node, parent, state 0=pre,1=post

    until stack.empty?
      node, parent, state = stack.pop
      kern = sf[node]
      if state == 0
        # pre
        total += counter[kern] if parent != -1
        counter[kern] += 1
        stack << [node, parent, 1]
        adj[node].each do |nei|
          next if nei == parent

          stack << [nei, node, 0]
        end
      else
        counter[kern] -= 1
      end
    end

    total
  end

  # 2273. Find Resultant Array After Removing Anagrams
  # @param {String[]} words
  # @return {String[]}
  def remove_anagrams(words)
    res = []
    res << words[0]

    (1...words.length).each do |i|
      res << words[i] if words[i].chars.sort.join != words[i - 1].chars.sort.join
    end

    res
  end

  # 3349. Adjacent Increasing Subarrays Detection I
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Boolean}
  def has_increasing_subarrays(nums, _k)
    n = nums.length
    prev_length = 0
    length = 1
    res = 0

    (0...n).each do |i|
      if nums[i] > nums[i - 1]
        length += 1
      else
        prev_length = length
        length = 1
      end

      best_length = [(length / 2), [prev_length, length].min].max
      res = [res, best_length].max
    end

    res >= k
  end
end
