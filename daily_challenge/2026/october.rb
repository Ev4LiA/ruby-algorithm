class October2026
  # 678. Valid Parenthesis String
  # @param {String} s
  # @return {Boolean}
  def check_valid_string(s)
    low = 0   # min possible number of unmatched '('
    high = 0  # max possible number of unmatched '('

    s.each_char do |c|
      case c
      when "("
        low += 1
        high += 1
      when ")"
        low -= 1
        high -= 1
      when "*"
        low -= 1   # treat '*' as ')'
        high += 1  # treat '*' as '('
      end

      return false if high.negative? # too many ')' even using all '*' as '('

      low = 0 if low.negative? # clamp: can't have negative open count
    end

    low.zero?
  end

  # 856. Score of Parentheses
  # @param {String} s
  # @return {Integer}
  def score_of_parentheses(s)
    stack = []

    stack.push(0)
    s.chars.each do |c|
      if c == "("
        stack.push(0)
      else
        v = stack.pop
        stack[-1] += [2 * v, 1].max
      end
    end
    stack[0]
  end

  # 921. Minimum Add to Make Parentheses Valid
  # @param {String} s
  # @return {Integer}
  def min_add_to_make_valid(s)
    open_brackets = 0
    min_added = 0

    s.chars.each do |c|
      if c == "("
        open_brackets += 1
      elsif open_brackets.positive?
        open_brackets -= 1
      else
        min_added += 1
      end
    end
    min_added + open_brackets
  end

  # 1021. Remove Outermost Parentheses
  # @param {String} s
  # @return {String}
  def remove_outer_parentheses(s)
    res = ""
    stack = []

    s.each_char do |c|
      stack.pop if c == ")"
      res += c unless stack.empty?

      stack << c if c == "("
    end

    res
  end

  # 1541. Minimum Insertions to Balance a Parentheses String
  # @param {String} s
  # @return {Integer}
  def min_insertions(s)
    insertions = 0   # total parentheses we must insert
    left = 0         # unmatched '(' seen so far
    i = 0
    n = s.length

    while i < n
      if s[i] == "("
        left += 1
        i += 1
      else
        # need to match this ')' with a '('
        if left > 0
          left -= 1
        else
          insertions += 1 # no '(' available, insert one
        end

        # need a consecutive '))' pair
        if i + 1 < n && s[i + 1] == ")"
          i += 2            # found the pair
        else
          insertions += 1   # insert the second ')'
          i += 1
        end
      end
    end

    # each leftover '(' still needs '))'
    insertions += left * 2
    insertions
  end
end
