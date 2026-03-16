class Answer
  def initialize
    @ans = [0, 0, 0]
  end

  def put(x)
    if x > @ans[0]
      @ans[2] = @ans[1]
      @ans[1] = @ans[0]
      @ans[0] = x
    elsif x != @ans[0] && x > @ans[1]
      @ans[2] = @ans[1]
      @ans[1] = x
    elsif x != @ans[0] && x != @ans[1] && x > @ans[2]
      @ans[2] = x
    end
  end

  def get
    ret = []
    @ans.each do |num|
      ret << num if num != 0
    end
    ret
  end
end
