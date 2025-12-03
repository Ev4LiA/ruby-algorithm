class December2025
  # 3623. Count Number of Trapezoids I
  # @param {Integer[][]} points
  # @return {Integer}
  def count_trapezoids(points)
    point_num = Hash.new(0)
    mod = (10**9) + 7
    ans = 0
    sum = 0
    points.each do |point|
      point_num[point[1]] += 1
    end

    point_num.each_value do |p_num|
      edge = ((p_num * (p_num - 1)) / 2) % mod
      ans = (ans + (edge * sum)) % mod
      sum = (sum + edge) % mod
    end

    ans
  end

  # 3625. Count Number of Trapezoids II
  # @param {Integer[][]} points
  # @return {Integer}
  def count_trapezoids2(points)
    mod = (10**9) + 7
    slope_to_intercept = Hash.new { |h, k| h[k] = [] }
    mid_to_slope = Hash.new { |h, k| h[k] = [] }
    ans = 0
    n = points.length
    (0...n).each do |i|
      x1 = points[i][0]
      y1 = points[i][1]
      (i + 1...n).each do |j|
        x2 = points[j][0]
        y2 = points[j][1]
        dx = x1 - x2
        dy = y1 - y2
        k = 0
        b = 0

        if x2 == x1
          k = mod
          b = x1
        else
          k = (1.0 * (y2 - y1)) / (x2 - x1)
          b = (1.0 * ((y1 * dx) - (x1 * dy))) / dx
        end

        k = 0.0 if k == -0.0
        b = 0.0 if b == -0.0
        mid = ((x1 + x2) * 10_000) + (y1 + y2)
        slope_to_intercept[k] << b
        mid_to_slope[mid] << k
      end
    end

    slope_to_intercept.each_value do |sti|
      next if sti.size == 1

      cnt = Hash.new(0)
      sti.each do |b|
        cnt[b] += 1
      end
      sum = 0
      cnt.each_value do |count|
        ans += sum * count
        sum += count
      end
    end

    mid_to_slope.each_value do |mts|
      next if mts.size == 1

      cnt = Hash.new(0)
      mts.each do |k|
        cnt[k] += 1
      end
      sum = 0
      cnt.each_value do |count|
        ans -= sum * count
        sum += count
      end
    end

    ans
  end
end
