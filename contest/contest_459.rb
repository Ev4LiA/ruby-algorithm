class Contest459
  # @param {Integer} n
  # @return {Boolean}
  def check_divisibility(n)
    digits = n.digits
    digit_sum = digits.sum
    digit_product = digits.reduce(1, :*)
    total = digit_sum + digit_product
    (n % total).zero?
  end

  # @param {Integer[][]} points
  # @return {Integer}
  # Counts horizontal trapezoids (at least one pair of horizontal sides) in O(n).
  def count_trapezoids(points)
    mod = 1_000_000_007
    y_counts = Hash.new(0)
    points.each { |(_, y)| y_counts[y] += 1 }

    sum_pairs = 0        # Σ C(ci, 2)
    sum_pairs_sq = 0     # Σ (C(ci, 2))^2

    y_counts.each_value do |cnt|
      next if cnt < 2

      pairs = cnt * (cnt - 1) / 2
      pairs %= mod

      sum_pairs = (sum_pairs + pairs) % mod
      sum_pairs_sq = (sum_pairs_sq + pairs * pairs % mod) % mod
    end

    # result = (Σ pairs choose 2) = (S^2 - Σ pairs^2) / 2
    res = (sum_pairs * sum_pairs - sum_pairs_sq) % mod
    res * 500_000_004 % mod # multiply by modular inverse of 2 (1e9+7)
  end

  # @param {Integer[][]} points
  # @return {Integer}
  # Counts convex quadrilaterals with at least one pair of parallel sides.
  # Works in O(n^2) for n ≤ 500 as required.
  def count_trapezoids_2(points)
    n = points.length
    return 0 if n < 4

    # Helper -> number of ways to pick 2 from k
    choose_2 = ->(k) { k * (k - 1) / 2 }

    # ------------------------------------------------------------------
    # 1. Count quadruples with at least one pair of *parallel* segments
    #    via grouping unordered point-pairs by slope.
    # ------------------------------------------------------------------
    slope_groups = Hash.new { |h, k| h[k] = { total: 0, point_deg: Hash.new(0) } }

    points.each_with_index do |(x1, y1), i|
      (i + 1...n).each do |j|
        x2, y2 = points[j]
        dx = x2 - x1
        dy = y2 - y1

        # Reduce slope to canonical form (dy, dx) with dx ≥ 0.
        if dx.zero?
          key = [1, 0]          # vertical
        elsif dy.zero?
          key = [0, 1]          # horizontal
        else
          g = dx.gcd(dy)
          dx_r = dx / g
          dy_r = dy / g
          if dx_r.negative?
            dx_r = -dx_r
            dy_r = -dy_r
          end
          key = [dy_r, dx_r]
        end

        grp = slope_groups[key]
        grp[:total] += 1
        grp[:point_deg][i] += 1
        grp[:point_deg][j] += 1
      end
    end

    trapezoid_with_parallel = 0
    slope_groups.each_value do |data|
      total_pairs = data[:total]
      next if total_pairs < 2

      cnt = choose_2.call(total_pairs)
      data[:point_deg].each_value { |d| cnt -= choose_2.call(d) }
      trapezoid_with_parallel += cnt
    end

    # ------------------------------------------------------------------
    # 1b. Remove degenerate quadruples where all 4 points lie on the same
    #     line (colinear). These were counted in the slope-group step
    #     but do NOT form a convex quadrilateral.
    # ------------------------------------------------------------------

    require 'set'
    line_points = Hash.new { |h, k| h[k] = Set.new }

    points.each_with_index do |(x1, y1), i|
      (i + 1...n).each do |j|
        x2, y2 = points[j]
        dx = x2 - x1
        dy = y2 - y1

        if dx.zero? && dy.zero?
          next # identical points can't happen per constraints
        elsif dx.zero?
          # vertical line, identify by x = const
          key = [:v, x1]
        else
          # canonical slope (dy_r, dx_r)
          g = dx.gcd(dy)
          dx_r = dx / g
          dy_r = dy / g
          if dx_r.negative?
            dx_r = -dx_r
            dy_r = -dy_r
          end
          # intercept: b = y - m x  => store numerator (dx_r*y - dy_r*x)
          intercept = dx_r * y1 - dy_r * x1
          key = [dy_r, dx_r, intercept]
        end

        line_points[key] << i
        line_points[key] << j
      end
    end

    colinear_quadruples = 0
    line_points.each_value do |pts_set|
      k = pts_set.size
      next if k < 4
      total_pairs_line = choose_2.call(k)
      cnt_line = choose_2.call(total_pairs_line) - k * choose_2.call(k - 1)
      colinear_quadruples += cnt_line
    end

    trapezoid_with_parallel -= colinear_quadruples

    # ------------------------------------------------------------------
    # 2. Count parallelograms (two pairs of parallel sides) so we don't
    #    double-count them (they were counted once for each slope).
    #    Use the fact that diagonals of a parallelogram share midpoint.
    # ------------------------------------------------------------------
    midpoint_groups = Hash.new { |h, k| h[k] = { total: 0, point_deg: Hash.new(0) } }

    points.each_with_index do |(x1, y1), i|
      (i + 1...n).each do |j|
        x2, y2 = points[j]
        mx = x1 + x2  # store twice the midpoint (avoids floats)
        my = y1 + y2
        key = [mx, my]

        grp = midpoint_groups[key]
        grp[:total] += 1
        grp[:point_deg][i] += 1
        grp[:point_deg][j] += 1
      end
    end

    parallelogram_count = 0
    midpoint_groups.each_value do |data|
      total_pairs = data[:total]
      next if total_pairs < 2

      cnt = choose_2.call(total_pairs)
      data[:point_deg].each_value { |d| cnt -= choose_2.call(d) }
      parallelogram_count += cnt
    end

    # Each parallelogram was counted twice in the first step (once per
    # slope group of its two opposite sides). Subtract one copy. Ensure non-negative.
    result = trapezoid_with_parallel - parallelogram_count
    result.negative? ? 0 : result
  end
end
