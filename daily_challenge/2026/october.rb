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
end
