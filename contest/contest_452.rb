require 'set'

class Contest452
  def can_partition(nums, target)
    total_product = nums.reduce(:*)

    return false if total_product != target * target

    n = nums.length

    (1...(1 << n) - 1).each do |mask|
        subset_product = 1

        nums.each_with_index do |num, i|
            if (mask & (1 << i)) != 0
                subset_product *= num
            end
        end

        return true if subset_product == target
    end

    false
  end

  # @param {Integer[][]} grid
  # @param {Integer} k
  # @return {Integer[][]}
  def min_abs_diff(grid, k)
    m = grid.length
    n = grid[0].length

    result = []

    # Iterate through all possible top-left corners for k×k submatrices
    (0..m-k).each do |i|
      row = []
      (0..n-k).each do |j|
        # Extract all values from k×k submatrix starting at (i,j)
        values = []
        (i...i+k).each do |x|
          (j...j+k).each do |y|
            values << grid[x][y]
          end
        end

        # Get unique values and sort them
        unique_values = values.uniq.sort

        # If only one unique value, min diff is 0
        if unique_values.length <= 1
          row << 0
        else
          # Find minimum difference between consecutive sorted values
          min_diff = Float::INFINITY
          (0...unique_values.length-1).each do |idx|
            diff = (unique_values[idx+1] - unique_values[idx]).abs
            min_diff = [min_diff, diff].min
          end
          row << min_diff
        end
      end
      result << row
    end

    result
  end

  # @param {String[]} classroom
  # @param {Integer} energy
  # @return {Integer}
  def min_moves(classroom, energy)
    m = classroom.length
    n = classroom[0].length

    start_row, start_col = nil, nil
    litter_positions = []

    (0...m).each do |i|
      (0...n).each do |j|
        if classroom[i][j] == 'S'
          start_row, start_col = i, j
        elsif classroom[i][j] == 'L'
          litter_positions << [i, j]
        end
      end
    end

    total_litter = litter_positions.length
    return 0 if total_litter == 0

    energy_cap = [energy, 20].min

    queue = [[start_row, start_col, [energy, energy_cap].min, 0, 0]]
    visited = {}

    directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]

    while !queue.empty?
      row, col, curr_energy, collected_mask, moves = queue.shift

      if collected_mask == (1 << total_litter) - 1
        return moves
      end

      norm_energy = [curr_energy, energy_cap].min
      state_key = [row, col, norm_energy, collected_mask]

      if visited.key?(state_key)
        next
      end
      visited[state_key] = true

      directions.each do |dr, dc|
        new_row = row + dr
        new_col = col + dc

        next if new_row < 0 || new_row >= m || new_col < 0 || new_col >= n
        next if classroom[new_row][new_col] == 'X'
        next if curr_energy <= 0

        new_energy = curr_energy - 1
        new_collected = collected_mask

        if classroom[new_row][new_col] == 'L'
          litter_index = litter_positions.index([new_row, new_col])
          if litter_index && (collected_mask & (1 << litter_index)) == 0
            new_collected |= (1 << litter_index)
          end
        end

        if classroom[new_row][new_col] == 'R'
          new_energy = energy
        end

        new_norm_energy = [new_energy, energy_cap].min
        new_state_key = [new_row, new_col, new_norm_energy, new_collected]

        if !visited.key?(new_state_key)
          queue << [new_row, new_col, new_energy, new_collected, moves + 1]
        end
      end
    end

    -1
  end
end
