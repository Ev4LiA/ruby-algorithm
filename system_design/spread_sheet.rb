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
  def get_value(formula)
    formula = formula[1..]
    i = formula.index("+")
    left = formula[0..i - 1]
    right = formula[i + 1..]

    left_value = left[0] >= "A" && left[0] <= "Z" ? (maps[left] || 0) : left.to_i
    right_value = right[0] >= "A" && right[0] <= "Z" ? (maps[right] || 0) : right.to_i

    left_value + right_value
  end
end

# Your Spreadsheet object will be instantiated and called as such:
# obj = Spreadsheet.new(rows)
# obj.set_cell(cell, value)
# obj.reset_cell(cell)
# param_3 = obj.get_value(formula)
