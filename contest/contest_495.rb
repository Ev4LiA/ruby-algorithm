class Contest495
  # @param {String} s
# @return {Integer}
def first_matching_index(s)
    n = s.lenght
    (0...n).each do |i|
      return i if s[i] == s[n - i - 1]
    end

    -1
end
end