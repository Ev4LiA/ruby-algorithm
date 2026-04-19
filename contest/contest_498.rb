class Contest498
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def first_stable_index(nums, _k)
    max_num = 0

    left_max = []
    right_min = []
    nums.each_with_index do |num, i|
      max_num = [max_num, num].max
      left_max[i] = max_num
    end

    min_num = max_num
    nums.reverse.each_with_index do |num, i|
      min_num = [min_num, num].min
      right_min[nums.length - 1 - i] = min_num
    end

    (0...nums.length).each do |i|
      return i if (left_max[i] - right_min[i]) <= k
    end

    -1
  end

  # @param {Integer} n
  # @param {Integer} m
  # @param {Integer[][]} sources
  # @return {Integer[][]}
  def color_grid(n, m, sources)
    dist = Array.new(n) { Array.new(m) }
    grid = Array.new(n) { Array.new(m, 0) }
    heap = []

    push = lambda do |item|
      heap << item
      i = heap.length - 1
      while i > 0
        p = (i - 1) / 2
        parent = heap[p]
        cur = heap[i]
        break if parent[0] < cur[0] || (parent[0] == cur[0] && parent[1] >= cur[1])

        heap[i], heap[p] = heap[p], heap[i]
        i = p
      end
    end

    pop = lambda do
      top = heap[0]
      last = heap.pop
      unless heap.empty?
        heap[0] = last
        i = 0
        loop do
          l = (2 * i) + 1
          break if l >= heap.length

          r = l + 1
          best = l
          left = heap[l]
          if r < heap.length
            right = heap[r]
            best = r if right[0] < left[0] || (right[0] == left[0] && right[1] > left[1])
          end
          child = heap[best]
          cur = heap[i]
          break if cur[0] < child[0] || (cur[0] == child[0] && cur[1] >= child[1])

          heap[i], heap[best] = heap[best], heap[i]
          i = best
        end
      end
      top
    end

    sources.each do |r, c, color|
      push.call([0, color, r, c])
    end

    dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]

    until heap.empty?
      d, color, r, c = pop.call
      next if dist[r][c] && (dist[r][c] < d || dist[r][c] == d)

      dist[r][c] = d
      grid[r][c] = color

      nd = d + 1
      dirs.each do |dr, dc|
        nr = r + dr
        nc = c + dc
        next if nr < 0 || nr >= n || nc < 0 || nc >= m

        push.call([nd, color, nr, nc]) if dist[nr][nc].nil? || nd < dist[nr][nc]
      end
    end

    grid
  end
end
