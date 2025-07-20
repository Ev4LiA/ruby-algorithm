class EasyProblem
  # @param {Integer} x
  # @return {Boolean}
  def is_palindrome(x)
    return false if x.negative?

    str = x.to_s
    str == str.reverse
  end
end
