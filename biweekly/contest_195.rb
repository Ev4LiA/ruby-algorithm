class Contest195
  # Count Substrings Without "abc"
  # @param {String} s
  # @return {Integer}
  def count_valid_substrings(s)
    n = s.length
    left = 0
    total = 0

    (0...n).each do |r|
      # s[r-2..r] == "abc" means every substring ending at r that starts at
      # or before r-2 contains "abc"; only starts r-1 and r stay valid.
      left = r - 1 if r >= 2 && s[r - 2, 3] == "abc"
      total += r - left + 1
    end

    total
  end

  # Remove All Elements in Groups
  # @param {Integer[]} types
  # @param {Integer[]} colors
  # @param {Integer[]} group_size
  # @return {Boolean}
  def can_remove_all(types, colors, group_size)
    # stack entries are [type, color, count]; neighbouring entries never share
    # type+color, and every count is a residue modulo that type's group size
    stack = []

    (0...types.length).each do |i|
      t = types[i]
      c = colors[i]

      if !stack.empty? && stack.last[0] == t && stack.last[1] == c
        stack.last[2] += 1
      else
        stack.push([t, c, 1])
      end

      # Peel off removable groups until the top of the stack is stable
      loop do
        break if stack.empty?

        t, _c, count = stack.last
        g = group_size[t]

        if count >= g
          count -= g
          if count.zero?
            # the whole run is gone: neighbours may now be adjacent and mergeable
            stack.pop
            if stack.length >= 2 && stack[-1][0] == stack[-2][0] && stack[-1][1] == stack[-2][1]
              merged = stack.pop
              stack[-1][2] += merged[2]
            end
          else
            stack[-1][2] = count
          end
          next
        end

        break
      end
    end

    stack.empty?
  end

  # Count Valid Substrings II
  # Counts substrings that do NOT contain "abc" as a subsequence.
  # @param {String} s
  # @return {Integer}
  def count_valid_substrings_ii(s)
    n = s.length
    invalid = 0
    last_a = -1  # index of the last 'a' seen
    best = -1    # furthest-right 'a' that already has a 'b' after it
    threshold = -1 # invalid windows ending anywhere past a 'c' start at or before this

    (0...n).each do |r|
      case s[r]
      when "c"
        threshold = best if best > threshold
      when "b"
        best = last_a if last_a > best
      else
        last_a = r
      end

      # s[l..r] holds an "abc" subsequence exactly when l <= threshold
      invalid += threshold + 1 if threshold >= 0
    end

    n * (n + 1) / 2 - invalid
  end

  # Repeated String Match
  # @param {String} a
  # @param {String} b
  # @param {Integer} x
  # @param {Integer} y
  # @return {Boolean}
  def repeated_string_match(a, b, x, y)
    la = a.length
    lb = b.length
    need = y * lb # length of b * y
    have = x * la # length of a * x
    return false if need > have

    # a * x is a prefix of the infinite string a a a ..., and b * y likewise
    # repeats with period |b|, so a witness can be shifted left by |a| until it
    # starts inside a[0...|a|]. Both sides are periodic with period
    # lcm(|a|, |b|), so comparing min(need, lcm) characters per start decides it.
    period = la.lcm(lb)
    limit = need < period ? need : period

    (0...la).each do |start|
      next if start + need > have # the shifted window must still fit in a * x

      j = 0
      j += 1 while j < limit && a[(start + j) % la] == b[j % lb]
      return true if j == limit
    end

    false
  end
end
