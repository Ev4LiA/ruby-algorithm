class September2026
  # 3568. Minimum Moves to Clean the Classroom
  # @param {String[]} classroom
  # @param {Integer} energy
  # @return {Integer}
  def min_moves(classroom, energy)
    m = classroom.size
    n = classroom[0].size

    # Assign each 'L' a bit id; locate the start 'S'.
    litter_id = {}
    sx = sy = 0
    classroom.each_with_index do |row, i|
      row.each_char.with_index do |c, j|
        case c
        when "S" then sx = i
                      sy = j
        when "L" then litter_id[[i, j]] = litter_id.size
        end
      end
    end

    k = litter_id.size
    return 0 if k.zero? # no litter to clean

    full_mask = (1 << k) - 1

    # best[i][j][mask] = max remaining energy seen at that state (-1 = unvisited)
    best = Array.new(m) { Array.new(n) { Array.new(1 << k, -1) } }
    best[sx][sy][0] = energy

    queue = [[sx, sy, 0, energy]] # x, y, mask, energy
    dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    steps = 0

    until queue.empty?
      nxt = []
      queue.each do |x, y, mask, e|
        return steps if mask == full_mask
        next if e.zero?           # can't move with no energy left

        dirs.each do |dx, dy|
          nx = x + dx
          ny = y + dy
          next if nx < 0 || nx >= m || ny < 0 || ny >= n

          c = classroom[nx][ny]
          next if c == "X"        # obstacle

          ne = c == "R" ? energy : e - 1
          nmask = c == "L" ? mask | (1 << litter_id[[nx, ny]]) : mask

          if ne > best[nx][ny][nmask]
            best[nx][ny][nmask] = ne
            nxt << [nx, ny, nmask, ne]
          end
        end
      end
      queue = nxt
      steps += 1
    end

    -1
  end

  # 3875. Construct Uniform Parity Array I
  # @param {Integer[]} nums1
  # @return {Boolean}
  def uniform_array(_nums1)
    true
  end

  # 3876. Construct Uniform Parity Array II
  # @param {Integer[]} nums1
  # @return {Boolean}
  def uniform_array(nums1)
    has_odd  = nums1.any?(&:odd?)
    has_even = nums1.any?(&:even?)

    # Already uniform (all odd or all even) — keep every element as-is.
    return true unless has_odd && has_even

    # Mixed parities: only "all odd" is achievable, and only when the
    # smallest element is odd (so every even has a smaller odd to subtract).
    nums1.min.odd?
  end
end
