class Contest462
  # @param {Integer[][]} grid
  # @param {Integer} x
  # @param {Integer} y
  # @param {Integer} k
  # @return {Integer[][]}
  def reverse_submatrix(grid, x, y, k)
    top = x
    bottom = x + k - 1

    while top < bottom
      (0...k).each do |offset|
        col = y + offset
        grid[top][col], grid[bottom][col] = grid[bottom][col], grid[top][col]
      end
      top += 1
      bottom -= 1
    end

    grid
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def sort_permutation(nums)
    k = nil
    nums.each_with_index do |val, idx|
      next if val == idx

      k = k.nil? ? idx : (k & idx)
    end
    k.nil? ? 0 : k
  end

  # @param {Integer[]} value
  # @param {Integer[]} limit
  # @return {Integer}
  def max_total(value, limit)
    n = value.length
    idx = Array.new(n) { |i| i }

    solve = lambda do |val, lim, ids|
      ids.sort! do |a, b|
        if lim[a] == lim[b]
          val[b] <=> val[a]
        else
          lim[a] <=> lim[b]
        end
      end

      active_limits = []
      total = 0
      dead_threshold = 0

      ids.each do |id|
        l = lim[id]
        next if l <= dead_threshold

        cur_active = active_limits.length
        next unless cur_active < l

        total += val[id]

        prev = cur_active
        ins = active_limits.bsearch_index { |x| x > l } || active_limits.length
        active_limits.insert(ins, l)

        x = prev + 1
        dead_threshold = x if x > dead_threshold

        cut = active_limits.bsearch_index { |v| v > x } || active_limits.length
        active_limits.shift(cut) if cut.positive?
      end

      total
    end

    solve.call(value, limit, idx)
  end

  # @param {Integer} n
  # @return {Integer}
  def special_palindrome(n)
    bound = (n + 1).to_s

    build_min_pal = lambda do |counts|
      total_len = 0
      (1..9).each { |d| total_len += counts[d] }
      half = []
      center = nil
      (1..9).each do |d|
        center = d if counts[d].odd?
        (counts[d] / 2).times { half << d }
      end
      left = half.sort
      right = left.reverse
      total_len.odd? ? (left + [center] + right).join : (left + right).join
    end

    build_pal_ge = lambda do |counts, bound_str|
      l = bound_str.length
      total = 0
      (1..9).each { |d| total += counts[d] }
      return nil unless total == l

      res = Array.new(l)
      half_len = l / 2
      has_center = (l.odd?)

      digits = (1..9).to_a

      rec = nil
      rec = lambda do |i, eq_prefix|
        if i == half_len
          if has_center
            start_val = eq_prefix ? (bound_str[i].ord - 48) : 1
            digits.each do |x|
              next unless counts[x] > 0
              next if x < start_val
              res[i] = x
              counts[x] -= 1
              s = res.join
              if !eq_prefix || s >= bound_str
                return s
              end
              counts[x] += 1
            end
            return nil
          else
            s = res.join
            return (!eq_prefix || s >= bound_str) ? s : nil
          end
        end

        bi = eq_prefix ? (bound_str[i].ord - 48) : 0
        if eq_prefix
          digits.each do |d|
            next unless counts[d] >= 2
            next if d < bi
            res[i] = d
            res[l - 1 - i] = d
            counts[d] -= 2
            ans = rec.call(i + 1, eq_prefix && (d == bi))
            return ans unless ans.nil?
            counts[d] += 2
          end
        else
          digits.each do |d|
            next unless counts[d] >= 2
            res[i] = d
            res[l - 1 - i] = d
            counts[d] -= 2
            ans = rec.call(i + 1, false)
            return ans unless ans.nil?
            counts[d] += 2
          end
        end
        nil
      end

      rec.call(0, true)
    end

    best = nil
    len_n = bound.length

    odds = [1, 3, 5, 7, 9]
    evens = [2, 4, 6, 8]

    odd_choices = [[]] + odds.map { |o| [o] }
    (0...(1 << evens.length)).each do |mask|
      even_sel = []
      evens.length.times do |i|
        even_sel << evens[i] if (mask & (1 << i)) != 0
      end

      odd_choices.each do |odd_sel|
        sel = odd_sel + even_sel
        next if sel.empty?

        counts = Array.new(10, 0)
        total_len = 0
        sel.each do |d|
          counts[d] = d
          total_len += d
        end

        next if total_len < len_n # too short

        candidate = nil
        if total_len > len_n
          candidate = build_min_pal.call(counts.dup)
        else
          candidate = build_pal_ge.call(counts.dup, bound)
        end

        next if candidate.nil?

        if best.nil?
          best = candidate
        else
          if candidate.length < best.length || (candidate.length == best.length && candidate < best)
            best = candidate
          end
        end
      end
    end

    best.nil? ? -1 : best.to_i
  end
end
