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
      a_bit = i < n1 ? a[n1 - 1 - i].ord - '0'.ord : 0
      b_bit = i < n2 ? b[n2 - 1 - i].ord - '0'.ord : 0

      s = (a_bit ^ b_bit) ^ c
      c_out = ((a_bit ^ b_bit) & c) | (a_bit & b_bit)

      res << (s + '0'.ord).chr
      c = c_out
      i += 1
    end

    res.reverse
    end
end

