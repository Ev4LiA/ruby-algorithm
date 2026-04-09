class Robot
  #     :type width: Integer
  #     :type height: Integer
  def initialize(width, height)
    @moved = false
  end

  #     :type num: Integer
  #     :rtype: Void
  def step(num); end

  #     :rtype: Integer[]
  def get_pos; end

  #     :rtype: String
  def get_dir; end
end

# Your Robot object will be instantiated and called as such:
# obj = Robot.new(width, height)
# obj.step(num)
# param_2 = obj.get_pos()
# param_3 = obj.get_dir()
