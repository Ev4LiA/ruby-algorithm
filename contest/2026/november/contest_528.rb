class Contest528
  # Count Subarrays With Bitwise AND Equal To Minimum
  # @param {Integer[]} nums
  # @return {Integer}
  def count_consistent(nums)
    n = nums.size
    ans = 0

    (0...n).each do |i|
      and_val = nums[i]
      min_val = nums[i]

      (i...n).each do |j|
        and_val &= nums[j]
        min_val = nums[j] if nums[j] < min_val
        ans += 1 if and_val == min_val
      end
    end

    ans
  end

  # Count Subarrays With Bitwise AND Equal To Minimum II
  # @param {Integer[]} nums
  # @return {Integer}
  def count_consistent_ii(nums)
    n = nums.size

    # Attribute every subarray to its leftmost minimum: prev index with value <=,
    # next index with value < (the stack breaks ties one way only).
    prev_le = Array.new(n, -1)
    next_lt = Array.new(n, n)

    stack = []
    n.times do |j|
      stack.pop while !stack.empty? && nums[stack[-1]] > nums[j]
      prev_le[j] = stack.empty? ? -1 : stack[-1]
      stack << j
    end

    stack.clear
    (n - 1).downto(0) do |j|
      stack.pop while !stack.empty? && nums[stack[-1]] >= nums[j]
      next_lt[j] = stack.empty? ? n : stack[-1]
      stack << j
    end

    # Segment tree of range ANDs: a range AND is a superset of mask exactly
    # when every element in it is, so it finds the nearest offender in O(log n).
    size = 1
    size <<= 1 while size < n
    full = (1 << 21) - 1
    tree = Array.new(size << 1, full)
    n.times { |i| tree[size + i] = nums[i] }
    (size - 1).downto(1) { |i| tree[i] = tree[i << 1] & tree[(i << 1) | 1] }

    ans = 0

    n.times do |j|
      m = nums[j]
      from_left = [prev_le[j], find_bad(tree, size, 0, j - 1, m, true)].max
      right = find_bad(tree, size, j + 1, n - 1, m, false)
      to_right = [next_lt[j], right < 0 ? n : right].min
      ans += (j - from_left) * (to_right - j)
    end

    ans
  end

  # Rightmost (from_right) or leftmost index in [lo, hi] that is not a bitwise
  # superset of mask; -1 when none.
  def find_bad(tree, size, lo, hi, mask, from_right)
    return -1 if lo > hi

    l = lo + size
    r = hi + size
    left_nodes = []
    right_nodes = []

    while l <= r
      if l.odd?
        left_nodes << l
        l += 1
      end
      if r.even?
        right_nodes << r
        r -= 1
      end
      l >>= 1
      r >>= 1
    end

    nodes = from_right ? right_nodes + left_nodes.reverse : left_nodes + right_nodes.reverse

    nodes.each do |node|
      next if (tree[node] & mask) == mask

      while node < size
        a = node << 1
        b = a | 1
        node = if from_right
                 (tree[b] & mask) == mask ? a : b
               else
                 (tree[a] & mask) == mask ? b : a
               end
      end
      return node - size
    end

    -1
  end

  # Maximize Score After Zeroing Subtrees
  # @param {Integer[]} parent
  # @param {Integer[]} op
  # @param {Integer[]} score
  # @return {Integer}
  def max_score(parent, op, score)
    n = parent.size
    children = Array.new(n) { [] }
    (1...n).each { |i| children[parent[i]] << i }

    order = [0]
    idx = 0
    while idx < order.size
      children[order[idx]].each { |c| order << c }
      idx += 1
    end

    best = Array.new(n, 0)

    order.reverse_each do |u|
      kids = children[u]
      if kids.empty?
        best[u] = score[u]
        next
      end

      total = 0
      low = Float::INFINITY
      kids.each do |c|
        total += best[c]
        low = best[c] if best[c] < low
      end

      # Zeroing a child drops that whole subtree to 0. op 1 must pick one,
      # op 0 takes it only when the subtree's best value is negative.
      best[u] = if op[u] == 1
                  score[u] + total - low
                else
                  score[u] + total - [0, low].min
                end
    end

    best[0]
  end

  # Game of Divisible Sums
  # @param {Integer[]} nums
  # @return {Integer}
  def max_difference(nums)
    n = nums.size
    best = Array.new(n + 1, 0)

    (n - 1).downto(0) do |i|
      sum = nums[i]
      # best[i] = the mover's score lead over the other player from index i
      cur = sum % 3 == 0 ? sum - best[i + 1] : sum + best[i + 1]

      if i + 1 < n
        sum += nums[i + 1]
        two = sum % 3 == 0 ? sum - best[i + 2] : sum + best[i + 2]
        cur = two if two > cur
      end

      best[i] = cur
    end

    best[0]
  end
end
