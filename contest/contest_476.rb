class Contest476
  # @param {Integer[]} nums
  # @return {Integer}
  def maximize_expression_of_three(nums)
    nums.sort!
    n = nums.size

    nums[n - 1] + nums[n - 2] - nums[0]
  end

  # @param {String} s
  # @return {Integer}
  def min_length_after_removals(s)
    (s.count("a") - s.count("b")).abs
  end

  # @param {Integer} n
  # @return {Integer}
  def count_distinct(n)
    digits = n.to_s.chars.map(&:to_i)
    len    = digits.size

    # pre-compute 9^k
    pow9 = Array.new(len + 1, 1)
    1.upto(len) { |i| pow9[i] = pow9[i - 1] * 9 }

    ans = 0
    # 1) numbers with fewer digits than n
    (1...len).each { |l| ans += pow9[l] }

    # 2) numbers with same length, prefix-wise DP
    tight = true
    digits.each_with_index do |d, i|
      break unless tight

      ans += (d.zero? ? 0 : d - 1) * pow9[len - i - 1] # choose smaller non-zero digit
      if d.zero? # current digit is zero ⇒ tight path breaks here
        tight = false
        break
      end

      # already broke tightness earlier
      # n itself has no zeros, include it
    end
    ans += 1 if tight

    ans
  end

  # @param {Integer[]} nums
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def count_stable_subarrays(nums, queries)
    # ---------- build maximal non-decreasing segments ----------
    starts = []
    ends = []
    seg_tot = []
    prefix = [0]
    n = nums.length
    q = queries.length

    seg_start = 0
    (0...n - 1).each do |i|
      next unless nums[i] > nums[i + 1] # a drop → segment ends at i

      starts << seg_start
      ends   << i
      len = i - seg_start + 1
      seg_tot << (len * (len + 1) / 2)
      prefix  << (prefix[-1] + seg_tot[-1])
      seg_start = i + 1
    end
    # last segment
    starts << seg_start
    ends   << (n - 1)
    len = n - seg_start
    seg_tot << (len * (len + 1) / 2)
    prefix  << (prefix[-1] + seg_tot[-1])

    # helper: locate segment that holds index idx
    find_seg = lambda do |idx|
      j = starts.bsearch_index { |s| s > idx }
      j ? j - 1 : starts.size - 1
    end

    # ---------- answer queries ----------
    ans = Array.new(q, 0)

    queries.each_with_index do |(l, r), qi|
      left_seg  = find_seg.call(l)
      right_seg = find_seg.call(r)

      if left_seg == right_seg # entirely within one segment
        len = r - l + 1
        ans[qi] = len * (len + 1) / 2
      else
        # left partial
        len_left = ends[left_seg] - l + 1
        total = len_left * (len_left + 1) / 2

        # right partial
        len_right = r - starts[right_seg] + 1
        total += len_right * (len_right + 1) / 2

        # full segments in between
        total += prefix[right_seg] - prefix[left_seg + 1] if left_seg + 1 <= right_seg - 1
        ans[qi] = total
      end
    end

    ans
  end
end
