require "debug"
class October2025
  # 1518. Water Bottles
  # @param {Integer} num_bottles
  # @param {Integer} num_exchange
  # @return {Integer}
  def num_water_bottles(num_bottles, num_exchange)
    res = num_bottles
    while num_bottles >= num_exchange
      res += num_bottles / num_exchange
      num_bottles = (num_bottles / num_exchange) + (num_bottles % num_exchange)
    end
    res
  end

  # 3100. Water Bottles II
  # @param {Integer} num_bottles
  # @param {Integer} num_exchange
  # @return {Integer}
  def max_bottles_drunk(num_bottles, num_exchange)
    res = num_bottles
    while num_bottles >= num_exchange
      res += 1
      num_bottles = num_bottles - num_exchange + 1
      num_exchange += 1
    end
    res
  end

  # 11. Container With Most Water
  # @param {Integer[]} height
  # @return {Integer}
  def max_area(height)
    l = 0
    r = height.length - 1
    max_area = 0
    while l < r
      max_area = [max_area, (r - l) * [height[l], height[r]].min].max
      if height[l] < height[r]
        l += 1
      else
        r -= 1
      end
    end
    max_area
  end

  # 417. Pacific Atlantic Water Flow
  # @param {Integer[][]} heights
  # @return {Integer[][]}
  def pacific_atlantic(heights)
    rows = heights.length
    cols = heights[0].length
    pacific_visited = []
    atlantic_visited = []
    pacific_queue = []
    atlantic_queue = []

    (0...rows).each do |row|
      (0...cols).each do |col|
        # Pacific Ocean (top and left edge)
        if row.zero? || col.zero?
          pacific_visited << [row, col]
          pacific_queue << [row, col]
        end

        # Atlatic Ocean (bottom and right edge)
        if row == rows - 1 || col == cols - 1
          atlantic_visited << [row, col]
          atlantic_queue << [row, col]
        end
      end
    end

    bfs = lambda do |queue, visited|
      until queue.empty?
        row, col = queue.shift
        directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
        directions.each do |dr, dc|
          new_row = row + dr
          new_col = col + dc
          next if new_row.negative? || new_row >= rows || new_col.negative? || new_col >= cols
          next if heights[new_row][new_col] < heights[row][col]
          next if visited.include?([new_row, new_col])

          visited << [new_row, new_col]
          queue << [new_row, new_col]
        end
      end
    end

    bfs.call(pacific_queue, pacific_visited)
    bfs.call(atlantic_queue, atlantic_visited)

    pacific_visited & atlantic_visited
  end

  # 778. Swim in Rising Water
  # @param {Integer[][]} grid
  def swim_in_water(grid)
    m = grid.length
    n = grid[0].length

    # Should use priority queue
    pq = []
    directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    seen = Set.new

    pq << [grid[0][0], 0, 0]

    until pq.empty?
      pq.sort_by! { |a| a[0] }
      max_d, r, c = pq.shift

      key = "#{r},#{c}"
      next if seen.include?(key)

      seen.add(key)

      return max_d if r == m - 1 && c == n - 1

      directions.each do |dir|
        nr = r + dir[0]
        nc = c + dir[1]
        if nr >= 0 && nr < m && nc >= 0 && nc < n && !seen.include?("#{nr},#{nc}")
          new_d = [max_d, grid[nr][nc]].max
          pq << [new_d, nr, nc]
        end
      end
    end

    -1
  end

  # 1488. Avoid Flood in The City
  # @param {Integer[]} rains
  # @return {Integer[]}
  def avoid_flood(rains)
    n = rains.length
    ans = Array.new(n, 1)
    last_rain = {}
    dry_days = []

    rains.each_with_index do |rain, i|
      if rain.zero?
        dry_days << i
      else
        ans[i] = -1
        if last_rain[rain]
          idx = dry_days.bsearch_index { |d| d > last_rain[rain] }

          return [] if idx.nil?

          dry_day = dry_days.delete_at(idx)
          ans[dry_day] = rain
        end
        last_rain[rain] = i
      end
    end

    ans
  end

  # 3494. Find the Minimum Amount of Time to Brew Potions
  # @param {Integer[]} skill
  # @param {Integer[]} mana
  # @return {Integer}
  def min_time(skill, mana)
    n = skill.length
    time = Array.new(n, 0)

    mana.each do |cost|
      cur_time = 0

      skill.each_with_index do |s, i|
        cur_time = [time[i], cur_time].max + (s * cost)
      end

      time[n - 1] = cur_time
      (n - 2).downto(0) do |j|
        time[j] = time[j + 1] - (skill[j + 1] * cost)
      end
    end

    time[n - 1]
  end

  # 3147. Taking Maximum Energy From the Mystic Dungeon
  # @param {Integer[]} energy
  # @param {Integer} k
  # @return {Integer}
  def maximum_energy(energy, k)
    n = energy.length
    ans = -Float::INFINITY

    (n - k...n).each do |i|
      sum = 0

      j = i
      while j >= 0
        sum += energy[j]
        ans = [ans, sum].max
        j -= k
      end
    end
    ans
  end

  # 3186. Maximum Total Damage With Spell Casting
  # @param {Integer[]} power
  # @return {Integer}
  def maximum_total_damage(power)
    count = power.tally

    keys = count.keys.sort
    n = keys.size
    dp = Array.new(n, 0)
    dp[0] = count[keys[0]] * keys[0]

    binary_search = lambda do |arr, target|
      l = 0
      r = arr.size - 1
      ans = -1
      while l <= r
        mid = (l + r) / 2
        if arr[mid] <= target
          ans = mid
          l = mid + 1
        else
          r = mid - 1
        end
      end

      ans
    end

    (1...n).each do |i|
      take = count[keys[i]] * keys[i]

      # Find the last index that is less than keys[i] - 3
      prev = binary_search.call(keys, keys[i] - 3)
      take += dp[prev] if prev >= 0

      dp[i] = [dp[i - 1], take].max
    end
    dp[n - 1]
  end
end

o = October2025.new
power = [1, 1, 3, 4]
o.maximum_total_damage(power)
