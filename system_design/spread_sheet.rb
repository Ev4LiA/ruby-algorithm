class Spreadsheet
  attr_accessor :maps

  # @param rows [Integer] number of rows
  def initialize(_rows)
    @maps = {}
  end

  # @param cell [String] cell name
  # @param value [Integer] value

  def set_cell(cell, value)
    maps[cell] = value
  end

  # @param cell [String] cell name

  def reset_cell(cell)
    maps[cell] = 0
  end

  # @param formula [String] formula
  # @return [Integer] value

  def get_value(_formula)
    0
  end
end

# Your Spreadsheet object will be instantiated and called as such:
# obj = Spreadsheet.new(rows)
# obj.set_cell(cell, value)
# obj.reset_cell(cell)
# param_3 = obj.get_value(formula)
