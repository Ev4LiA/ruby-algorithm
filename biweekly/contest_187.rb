class Contest187
  # Rearrange String to Avoid Character Pair©leetcode
  # @param {String} s
  # @param {Character} x
  # @param {Character} y
  # @return {String}
  def rearrange_string(s, x, y)
    y_chars = s.chars.select { |c| c == y }
    x_chars = s.chars.select { |c| c == x }
    other_chars = s.chars.select { |c| c != x && c != y }

    (y_chars + other_chars + x_chars).join
  end

  # Maximum Value of an Alternating Sequence
  # @param {Integer} n
  # @param {Integer} s
  # @param {Integer} m
  # @return {Integer}
  def maximum_value(n, s, m)
    k = n - 1

    return s if k == 0

    u = (k + 1) / 2 # number of "up" steps (ceil(k/2)), starting with up
    d = u - 1              # number of "down" steps completed before the final up-peak

    s + (u * m) - d
  end
end
