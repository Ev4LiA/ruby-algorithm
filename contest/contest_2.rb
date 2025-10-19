require "debug"

class Contest2
  # @param {String} s
  # @param {String} t
  # @return {Character}
  def find_the_difference(s, t)
    count = s.chars.tally
    t.chars.each do |char|
      return char unless count.key?(char)

      count[char] -= 1
      return char if count[char].negative?
    end
    ""
  end

  # @param {Integer} n
  # @return {Integer}
  def last_remaining(n)
    left = true
    remaining = n
    jump_step = 1
    head = 1

    while remaining > 1
      head += jump_step if left || remaining.odd?
      jump_step *= 2
      remaining /= 2
      left = !left
    end

    head
  end

  # @param {Integer[][]} rectangles
  # @return {Boolean}
  def is_rectangle_cover(rectangles)
    calc_area = lambda do |arr|
      (arr[2] - arr[0]) * (arr[3] - arr[1])
    end

    total_area = rectangles.reduce(0) { |sum, arr| sum + calc_area.call(arr) }

    min_x = rectangles.min_by { |arr| arr[0] }[0]
    min_y = rectangles.min_by { |arr| arr[1] }[1]
    max_x = rectangles.max_by { |arr| arr[2] }[2]
    max_y = rectangles.max_by { |arr| arr[3] }[3]

    big_area = calc_area.call([min_x, min_y, max_x, max_y])

    return false unless big_area == total_area

    corners = Hash.new(0)

    rectangles.each do |(x1, y1, x2, y2)|
      [[x1, y1], [x1, y2], [x2, y1], [x2, y2]].each do |pt|
        corners[pt] ^= 1 # toggle presence using parity (0/1)
      end
    end

    expected = [[min_x, min_y], [min_x, max_y], [max_x, min_y], [max_x, max_y]]

    # All four big corners should have value 1, others 0
    corners.each do |pt, val|
      if expected.include?(pt)
        return false unless val == 1
      else
        return false unless val.zero?
      end
    end

    true
  end
end
