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
end
