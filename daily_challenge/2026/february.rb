class February2026
  # 3010. Divide an Array Into Subarrays With Minimum Cost I
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_cost(nums)
    nums[1..-1] = nums[1..-1].sort!
    nums[0] + nums[1] + nums[2]
  end

  # 3714. Longest Balanced Substring II
  # @param {String} s
  # @return {Integer}
  def longest_balanced(s)
    n = s.length

    return n if n <= 1

    single = 1
    cur = 1
    (1...n).each do |i|
      if s[i] == s[i - 1]
        cur += 1
      else
        single = [cur, single].max
        cur = 1
      end
    end

    single = [single, cur].max
    res = single

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
        res = [res, len].max
      else
        seen[key] = i
      end
    end

    pairs = [%w[a b c], %w[a c b], %w[b c a]]

    pairs.each do |x, y, z|
      diff = 0
      last_other = -1
      pos = { 0 => - 1 }

      (0...n).each do |i|
        ch = s[i]

        if ch == z
          diff = 0
          last_other = i
          pos = { 0 => i }
          next
        end

        diff += 1 if ch == x
        diff -= 1 if ch == y

        if pos.key?(diff)
          len = i - pos[diff]
          res = [len, res].max
        else
          pos[diff] = i
        end
      end
    end

    res
  end

  # 799. Champagne Tower
  # @param {Integer} poured
  # @param {Integer} query_row
  # @param {Integer} query_glass
  # @return {Float}
  def champagne_tower(poured, query_row, query_glass)
    tower = Array.new(102) { Array.new(102, 0.0) }
    tower[0][0] = poured

    (0..query_row).each do |r|
      (0..r).each do |c|
        q = (tower[r][c] - 1.0) / 2.0
        if q.positive?
          tower[r + 1][c] += q
          tower[r + 1][c + 1] += q
        end
      end
    end

    [tower[query_row][query_glass], 1].min
  end

  # 67. Add Binary
  # @param {String} a
  # @param {String} b
  # @return {String}
  def add_binary(a, b)
    n1 = a.length
    n2 = b.length
    max = [n1, n2].max
    c = 0
    i = 0

    res = +""

    while i < max || c > 0
      a_bit = i < n1 ? a[n1 - 1 - i].ord - "0".ord : 0
      b_bit = i < n2 ? b[n2 - 1 - i].ord - "0".ord : 0

      s = (a_bit ^ b_bit) ^ c
      c_out = ((a_bit ^ b_bit) & c) | (a_bit & b_bit)

      res << (s + "0".ord).chr
      c = c_out
      i += 1
    end

    res.reverse
  end

  # 190. Reverse Bits
  # @param {Integer} n, a positive integer
  # @return {Integer}
  def reverse_bits(n)
    result = 0
    32.times do
      result <<= 1
      result |= (n & 1)
      n >>= 1
    end
    result
  end

  # 401. Binary Watch
  # @param {Integer} turned_on
  # @return {String[]}
  def read_binary_watch(turned_on)
    res = []
    12.times do |h|
      60.times do |m|
        res << "#{h}:#{m.to_s.rjust(2, '0')}" if h.to_s(2).count("1") + m.to_s(2).count("1") == turned_on
      end
    end
    res
  end

  # 693. Binary Number with Alternating Bits
  # @param {Integer} n
  # @return {Boolean}
  def has_alternating_bits(n)
    prev_bit = n & 1
    n >>= 1

    while n > 0
      current_bit = n & 1
      return false if current_bit == prev_bit

      prev_bit = current_bit
      n >>= 1
    end

    true
  end

  # 696. Count Binary Substrings
  # @param {String} s
  # @return {Integer}
  def count_binary_substrings(s)
    count = 0
    prev_run_length = 0
    cur_run_length = 1

    (1...s.length).each do |i|
      if s[i] == s[i - 1]
        cur_run_length += 1
      else
        count += [prev_run_length, cur_run_length].min
        prev_run_length = cur_run_length
        cur_run_length = 1
      end
    end

    count + [prev_run_length, cur_run_length].min
  end

  # 761. Special Binary String
  # @param {String} s
  # @return {String}
  def make_largest_special(s)
    return s if s.empty?

    count = 0
    start = 0
    subs = []

    s.chars.each_with_index do |ch, i|
      count += (ch == "1" ? 1 : -1)
      if count.zero?
        subs << "1#{make_largest_special(s[start + 1...i])}0"
        start = i + 1
      end
    end

    subs.sort.reverse.join
  end

  # 762. Prime Number of Set Bits in Binary Representation
  # @param {Integer} left
  # @param {Integer} right
  # @return {Integer}
  def count_prime_set_bits(left, right)
    primes = [2, 3, 5, 7, 11, 13, 17, 19]
    count = 0

    (left..right).each do |num|
      set_bits = num.to_s(2).count("1")
      count += 1 if primes.include?(set_bits)
    end

    count
  end

  # 868. Binary Gap
  # @param {Integer} n
  # @return {Integer}
  def binary_gap(n)
    last_position = nil
    max_gap = 0

    32.times do |i|
      next unless (n & (1 << i)) != 0

      max_gap = [max_gap, i - last_position].max if last_position
      last_position = i
    end

    max_gap
  end

  # 1461. Check If a String Contains All Binary Codes of Size K
  # @param {String} s
  # @param {Integer} k
  # @return {Boolean}
  def has_all_codes(s, k)
    needed = 1 << k
    seen = Array.new(needed, false)
    mask = needed - 1
    hash = 0

    s.chars.each_with_index do |ch, i|
      hash = ((hash << 1) & mask) | (ch.ord - "0".ord)
      next unless i >= k - 1 && !seen[hash]

      seen[hash] = true
      needed -= 1
      return true if needed.zero?
    end

    needed.zero?
  end

  # 1022. Sum of Root To Leaf Binary Numbers
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
  def sum_root_to_leaf(root)
    return 0 unless root

    stack = [[root, root.val]]
    total_sum = 0

    until stack.empty?
      node, current_value = stack.pop

      total_sum += current_value if node.left.nil? && node.right.nil?

      stack << [node.right, (current_value << 1) | node.right.val] if node.right
      stack << [node.left, (current_value << 1) | node.left.val] if node.left
    end

    total_sum
  end

  # 1356. Sort Integers by The Number of 1 Bits
  # @param {Integer[]} arr
  # @return {Integer[]}
  def sort_by_bits(arr)
    arr.sort_by { |x| [x.to_s(2).count("1"), x] }
  end

  # 1404. Number of Steps to Reduce a Number in Binary Representation to One
  # @param {String} s
  # @return {Integer}
  def num_steps(s)
    steps = 0
    n = s.length

    while n > 1
      s = if s[-1] == "0"
            s[0...-1]
          else
            (s.to_i(2) + 1).to_s(2)
          end
      steps += 1
      n = s.length
    end

    steps
  end

  # 3666. Minimum Operations to Equalize Binary Strings
  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def min_operations(s, k)
    count_0 = s.count("0")
    zero = 0
    len  = s.length

    # count zeros using the same bit trick as Java (~char & 1)
    (0...len).each do |i|
      zero += (~s[i].ord) & 1
    end

    return 0 if zero == 0

    if len == k
      # ((zero == len ? 1 : 0) << 1) - 1
      val = (zero == len ? 1 : 0)
      return (val << 1) - 1
    end

    base = len - k

    # odd = Math.max( ceil(zero / k), ceil((len - zero) / base) )
    odd = [
      (zero + k - 1) / k,
      (len - zero + base - 1) / base
    ].max

    # make odd actually odd: odd += ~odd & 1
    odd += (~odd) & 1

    # even = Math.max( ceil(zero / k), ceil(zero / base) )
    even = [
      (zero + k - 1) / k,
      (zero + base - 1) / base
    ].max

    # make even actually even: even += even & 1
    even += even & 1

    res = Float::INFINITY

    # if ((k & 1) == (zero & 1)) res = Math.min(res, odd)
    res = [res, odd].min if (k & 1) == (zero & 1)

    # if ((~zero & 1) == 1) res = Math.min(res, even)
    res = [res, even].min if ((~zero) & 1) == 1

    res == Float::INFINITY ? -1 : res
  end

  # 1680. Concatenation of Consecutive Binary Numbers
  # @param {Integer} n
  # @return {Integer}
  def concatenated_binary(n)
    mod = 10**9 + 7
    result = 0

    (1..n).each do |i|
      length = i.to_s(2).length
      result = ((result << length) | i) % mod
    end

    result
  end

  # 1689. Partitioning Into Minimum Number Of Deci-Binary Numbers
  # @param {String} n
  # @return {Integer}
  def min_partitions(n)
    n.chars.map(&:to_i).max
  end
end
