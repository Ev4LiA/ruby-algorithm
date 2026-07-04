class Contest185
  # @param {Integer} m
  # @param {Integer} n
  # @return {String[]}
  def create_grid(m, n)
    # Start with all cells blocked
    grid = Array.new(m) { Array.new(n, "#") }

    # Go right along the top row from (0,0) to (0,n-1)
    (0...n).each do |j|
      grid[0][j] = "."
    end

    # Then go down along the last column from (0,n-1) to (m-1,n-1)
    (0...m).each do |i|
      grid[i][n - 1] = "."
    end

    grid.map(&:join)
  end

  # @param {Integer[]} lights
  # @return {Integer}
  def min_lights(lights)
    n = lights.length

    # diff[i] will be used in a prefix sum to know how many original bulbs cover position i
    diff = Array.new(n + 1, 0)

    # Build coverage from existing bulbs using a difference array
    i = 0
    while i < n
      v = lights[i]
      if v > 0
        # This bulb covers [l, r] (clamped to [0, n-1])
        l = i - v
        l = 0 if l < 0
        r = i + v
        r = n - 1 if r >= n

        # Mark interval [l, r] as +1 in diff array
        diff[l] += 1
        diff[r + 1] -= 1 if r + 1 < n
      end
      i += 1
    end

    # Convert diff to actual visibility: visible[i] = true if covered by any existing bulb
    visible = Array.new(n, false)
    cur = 0
    i = 0
    while i < n
      cur += diff[i]
      visible[i] = cur > 0
      i += 1
    end

    # Greedily place new bulbs to cover remaining dark positions
    res = 0
    i = 0
    while i < n
      if visible[i]
        # Already lit: move to next position
        i += 1
      else
        # Place a new bulb centered at i+1: it will cover [i, i+2]
        # So after placing it, we can skip next 3 positions
        res += 1
        i += 3
      end
    end

    res
  end
end
