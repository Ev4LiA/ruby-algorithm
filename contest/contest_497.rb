class Contest497
  # @param {Integer[][]} matrix
  # @return {Integer[]}
  def find_degrees(matrix)
    hash = Hash.new(0)
    matrix.each_with_index do |edges, i|
      hash[i] = 0
      edges.each do |node|
        hash[i] += 1 if node == 1
      end
    end
    hash.values
  end

  # @param {Integer[]} sides
  # @return {Float[]}
  def internal_angles(sides)
    a, b, c = sides.map(&:to_f)

    return [] unless a + b > c && a + c > b && b + c > a

    angle_a = Math.acos([[((b * b) + (c * c) - (a * a)) / (2.0 * b * c), 1.0].min, -1.0].max) * 180.0 / Math::PI
    angle_b = Math.acos([[((a * a) + (c * c) - (b * b)) / (2.0 * a * c), 1.0].min, -1.0].max) * 180.0 / Math::PI
    angle_c = 180.0 - angle_a - angle_b

    [angle_a, angle_b, angle_c].sort
  end
end
