class September2026
  # 3568. Minimum Moves to Clean the Classroom
  # @param {String[]} classroom
  # @param {Integer} energy
  # @return {Integer}
  def min_moves(classroom, energy)
    m = classroom.size
    n = classroom[0].size

    # Assign each 'L' a bit id; locate the start 'S'.
    litter_id = {}
    sx = sy = 0
    classroom.each_with_index do |row, i|
      row.each_char.with_index do |c, j|
        case c
        when "S" then sx = i
                      sy = j
        when "L" then litter_id[[i, j]] = litter_id.size
        end
      end
    end

    k = litter_id.size
    return 0 if k.zero? # no litter to clean

    full_mask = (1 << k) - 1

    # best[i][j][mask] = max remaining energy seen at that state (-1 = unvisited)
    best = Array.new(m) { Array.new(n) { Array.new(1 << k, -1) } }
    best[sx][sy][0] = energy

    queue = [[sx, sy, 0, energy]] # x, y, mask, energy
    dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    steps = 0

    until queue.empty?
      nxt = []
      queue.each do |x, y, mask, e|
        return steps if mask == full_mask
        next if e.zero?           # can't move with no energy left

        dirs.each do |dx, dy|
          nx = x + dx
          ny = y + dy
          next if nx < 0 || nx >= m || ny < 0 || ny >= n

          c = classroom[nx][ny]
          next if c == "X"        # obstacle

          ne = c == "R" ? energy : e - 1
          nmask = c == "L" ? mask | (1 << litter_id[[nx, ny]]) : mask

          if ne > best[nx][ny][nmask]
            best[nx][ny][nmask] = ne
            nxt << [nx, ny, nmask, ne]
          end
        end
      end
      queue = nxt
      steps += 1
    end

    -1
  end

  # 3875. Construct Uniform Parity Array I
  # @param {Integer[]} nums1
  # @return {Boolean}
  def uniform_array(_nums1)
    true
  end

  # 3876. Construct Uniform Parity Array II
  # @param {Integer[]} nums1
  # @return {Boolean}
  def uniform_array(nums1)
    has_odd  = nums1.any?(&:odd?)
    has_even = nums1.any?(&:even?)

    # Already uniform (all odd or all even) — keep every element as-is.
    return true unless has_odd && has_even

    # Mixed parities: only "all odd" is achievable, and only when the
    # smallest element is odd (so every even has a smaller odd to subtract).
    nums1.min.odd?
  end

  # 3903. Smallest Stable Index I
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def first_stable_index(nums, k)
    n = nums.length

    # suffix_min[i] = min(nums[i..n-1])
    suffix_min = Array.new(n)
    suffix_min[n - 1] = nums[n - 1]
    (n - 2).downto(0) { |i| suffix_min[i] = [nums[i], suffix_min[i + 1]].min }

    prefix_max = -Float::INFINITY
    nums.each_index do |i|
      prefix_max = [prefix_max, nums[i]].max # max(nums[0..i])
      return i if prefix_max - suffix_min[i] <= k
    end

    -1
  end

  # 3904. Smallest Stable Index II
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def first_stable_index_II(nums, k)
    max_num = 0

    left_max = []
    right_min = []
    nums.each_with_index do |num, i|
      max_num = [max_num, num].max
      left_max[i] = max_num
    end

    min_num = max_num
    nums.reverse.each_with_index do |num, i|
      min_num = [min_num, num].min
      right_min[nums.length - 1 - i] = min_num
    end

    (0...nums.length).each do |i|
      return i if (left_max[i] - right_min[i]) <= k
    end

    -1
  end

  # 115. Distinct Subsequences
  # # @param {String} s
  # @param {String} t
  # @return {Integer}
  def num_distinct(s, t)
    _ = s.length
    n = t.length
    # dp[j] = number of distinct subsequences of s-so-far equal to t[0...j]
    dp = Array.new(n + 1, 0)
    dp[0] = 1 # empty t matches once

    s.each_char do |sc|
      # iterate j downward so each s char is used at most once per state
      n.downto(1) do |j|
        dp[j] += dp[j - 1] if sc == t[j - 1]
      end
    end

    dp[n]
  end

  # 940. Distinct Subsequences II
  # @param {String} s
  # @return {Integer}
  def distinct_subseq_ii(s)
    mod = 1_000_000_007
    # dp = number of distinct non-empty subsequences seen so far
    dp = 0
    # last[c] = dp value right before the previous time char c was added
    last = Hash.new(0)

    s.each_char do |c|
      prev = dp
      # new total = (old total * 2 + 1), then subtract the duplicates
      # contributed the last time this same char was appended
      dp = ((2 * dp) + 1 - last[c]) % mod
      last[c] = prev + 1
    end

    dp % mod
  end

  # 3870. Count Commas in Range
  # @param {Integer} n
  # @return {Integer}
  def count_commas(n)
    [n - 999, 0].max
  end

  # 3871. Count Commas in Range II
  # @param {Integer} n
  # @return {Integer}
  def count_commas(n)
    total = 0
    power = 1000 # 10**3, the first number that needs a comma
    while power <= n
      total += n - power + 1 # every value in [power, n] gains one more comma here
      power *= 1000
    end
    total
  end

  # 2265. Count Nodes Equal to Average of Subtree
  # Definition for a binary tree node.
  # class TreeNode
  #     attr_accessor :val, :left, :right
  #     def initialize(val = 0, left = nil, right = nil)
  #         @val = val
  #         @left = left
  #         @right = right
  #     end
  # end

  # @param {TreeNode} root
  # @return {Integer}
  def average_of_subtree(root)
    count = 0

    # Post-order DFS. Returns [sum_of_subtree, node_count].
    dfs = lambda do |node|
      return [0, 0] unless node

      left_sum, left_count = dfs.call(node.left)
      right_sum, right_count = dfs.call(node.right)

      total_sum = left_sum + right_sum + node.val
      total_count = left_count + right_count + 1

      count += 1 if total_sum / total_count == node.val

      [total_sum, total_count]
    end

    dfs.call(root)
    count
  end

  # 3483. Unique 3-Digit Even Numbers
  # @param {Integer[]} digits
  # @return {Integer}
  def total_numbers(digits)
    seen = {}
    digits.each_index do |i|
      digits.each_index do |j|
        next if j == i

        digits.each_index do |k|
          next if k == i || k == j

          a = digits[i]
          b = digits[j]
          c = digits[k]
          next if a == 0        # no leading zeros
          next if c.odd?        # must be even

          seen[(a * 100) + (b * 10) + c] = true
        end
      end
    end
    seen.size
  end

  # 3414. Maximum Score of Non-overlapping Intervals
  # @param {Integer[][]} intervals
  # @return {Integer[]}
  def maximum_weight(intervals)
    n = intervals.length

    # Original indices sorted by left boundary
    idx   = (0...n).sort_by { |i| intervals[i][0] }
    lefts = idx.map { |i| intervals[i][0] }

    # dp[p][k] = [best_score, sorted_indices] using sorted intervals [p..],
    # picking at most k of them.
    dp = Array.new(n + 1) { Array.new(5) }
    (0..4).each { |k| dp[n][k] = [0, []] }

    (n - 1).downto(0) do |p|
      orig = idx[p]
      r    = intervals[orig][1]
      w    = intervals[orig][2]

      # First index q > p whose left boundary is strictly past r (non-overlapping).
      lo = p + 1
      hi = n
      while lo < hi
        mid = (lo + hi) / 2
        lefts[mid] > r ? hi = mid : lo = mid + 1
      end
      nxt = lo

      (0..4).each do |k|
        skip = dp[p + 1][k]
        if k.zero?
          dp[p][k] = skip
        else
          sub  = dp[nxt][k - 1]
          take = [w + sub[0], (sub[1] + [orig]).sort]
          dp[p][k] = better(skip, take)
        end
      end
    end

    dp[0][4][1]
  end

  # Prefer higher score; on ties prefer the lexicographically smaller index array.
  def better(a, b)
    return a if a[0] > b[0]
    return b if b[0] > a[0]

    (a[1] <=> b[1]) <= 0 ? a : b
  end

  # 2472. Maximum Number of Non-overlapping Palindrome Substrings
  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def max_palindromes(s, k)
    n = s.length
    count = 0
    boundary = 0 # index up to which characters are already consumed

    (0...n).each do |center|
      # try odd-length (center, center) and even-length (center, center+1)
      [[center, center], [center, center + 1]].each do |l0, r0|
        l = l0
        r = r0
        while l >= boundary && r < n && s[l] == s[r]
          if r - l + 1 >= k
            count += 1
            boundary = r + 1
            break
          end
          l -= 1
          r += 1
        end
      end
    end

    count
  end

  # 835. Image Overlap
  # @param {Integer[][]} img1
  # @param {Integer[][]} img2
  # @return {Integer}
  def largest_overlap(img1, img2)
    n = img1.length
    magic = 100 # > max possible offset (since n <= 30)
    ones1 = []
    ones2 = []

    # collect coordinates of 1s in both images
    (0...n).each do |i|
      (0...n).each do |j|
        ones1 << [i, j] if img1[i][j] == 1
        ones2 << [i, j] if img2[i][j] == 1
      end
    end

    return 0 if ones1.empty? || ones2.empty?

    counts = Hash.new(0)
    max_overlap = 0

    # for every pair of 1s, compute translation vector
    ones1.each do |ax, ay|
      ones2.each do |bx, by|
        key = ((ax - bx) * magic) + (ay - by)
        counts[key] += 1
        max_overlap = [max_overlap, counts[key]].max
      end
    end

    max_overlap
  end

  # 1621. Number of Sets of K Non-Overlapping Line Segments
  # @param {Integer} n
  # @param {Integer} k
  # @return {Integer}
  def number_of_sets(n, k)
    mod = (10**9) + 7

    # Answer = C(n + k - 1, 2k) mod (1e9 + 7)
    top = n + k - 1
    bot = 2 * k
    return 0 if bot > top

    # Precompute factorials up to top
    fact = Array.new(top + 1, 1)
    (1..top).each { |i| fact[i] = fact[i - 1] * i % mod }

    # Modular inverse via Fermat's little theorem
    inv = ->(a) { a.pow(mod - 2, mod) }

    fact[top] * inv.call(fact[bot]) % mod * inv.call(fact[top - bot]) % mod
  end

  # 1477. Find Two Non-overlapping Sub-arrays Each With Target Sum
  # @param {Integer[]} arr
  # @param {Integer} target
  # @return {Integer}
  def min_sum_of_lengths(arr, target)
    n = arr.length
    inf = Float::INFINITY

    # best[i] = min length of a valid subarray within arr[0..i]
    best = inf
    ans  = inf

    left = 0
    sum  = 0

    (0...n).each do |right|
      sum += arr[right]

      # shrink window until sum <= target
      while sum > target
        sum -= arr[left]
        left += 1
      end

      next unless sum == target

      cur_len = right - left + 1
      # pair this subarray with the best one lying entirely to its left
      ans = [ans, best + cur_len].min if best != inf
      best = [best, cur_len].min
    end

    ans == inf ? -1 : ans
  end
end
