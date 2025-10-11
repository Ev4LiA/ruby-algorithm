require "debug"

class Contest1
  # 386. Lexicographical Numbers
  # @param {Integer} n
  # @return {Integer[]}
  def lexical_order(n)
    res = []
    generate_lexical_number = lambda do |array, current, limit|
      return if current > limit

      array << current
      10.times do |i|
        next_number = (current * 10) + i
        break unless next_number <= limit

        generate_lexical_number.call(array, next_number, limit)
      end
    end
    (1..9).each do |i|
      generate_lexical_number.call(res, i, n)
    end

    res
  end

  # 387. First Unique Character in a String
  # @param {String} s
  # @return {Integer}
  def first_uniq_char(s)
    map = s.chars.tally
    s.chars.each_with_index do |char, index|
      return index if map[char] == 1
    end

    -1
  end

  # 388. Longest Absolute File Path
  # @param {String} input
  # @return {Integer}
  def length_longest_path(input)
    lines = input.split("\n")

    depth_map = { 0 => 0 }
    max_length = 0

    lines.each do |line|
      depth = line.count("\t")
      name = line.sub(/\t+/, "")
      if name.include?(".")
        max_length = [max_length, depth_map[depth] + name.length].max
      else
        depth_map[depth + 1] = depth_map[depth] + name.length + 1
      end
    end

    max_length
  end
end
