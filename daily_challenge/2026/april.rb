class April2026
  # 874. Walking Robot Simulation
  # @param {Integer[]} commands
  # @param {Integer[][]} obstacles
  # @return {Integer}
  def robot_sim(commands, obstacles)
    lb = 30_000
    ob_set = Set.new

    obstacles.each do |ob|
      x = ob[0] + lb
      y = ob[1] + lb
      ob_set.add((x << 16) + y)
    end

    dir = [[0, 1], [-1, 0], [0, -1], [1, 0]]
    x = 0
    y = 0
    face = 0
    dx = dir[face][0]
    dy = dir[face][1]
    max_d2 = 0

    commands.each do |c|
      case c
      when -2
        face = (face + 1) & 3
        dx = dir[face][0]
        dy = dir[face][1]
      when -1
        face = (face + 3) & 3
        dx = dir[face][0]
        dy = dir[face][1]
      else
        c.times do
          x += dx
          y += dy
          if ob_set.include?(((x + lb) << 16) + y + lb)
            x -= dx
            y -= dy
            break
          end
          d2 = (x * x) + (y * y)
          max_d2 = d2 if d2 > max_d2
        end
      end
    end

    max_d2
  end

  # 3653. XOR After Range Multiplication Queries I
  # @param {Integer} n
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def xor_after_queries(_n, queries)
    mod = 1_000_000_007

    n = nums.length
    for q in queries
      l = q[0]
      r = q[1]
      k = q[2]
      v = q[3]
      i = l
      while i <= r
        nums[i] = ((nums[i].to_i * v) % mod).to_i
        i += k
      end
    end
    res = 0
    nums.each do |x|
      res ^= x
    end
    res
  end

  # 3655. XOR After Range Multiplication Queries II
  # @param {Integer} n
  # @param {Integer[][]} queries
  # @return {Integer[]}
  def xor_after_queries_ii(n, queries)
    mod = (10**9) + 7

    mod_pow = lambda do |a, e, m|
      res = 1
      base = a % m
      while e > 0
        res = (res * base) % m if e.odd?
        base = (base * base) % m
        e >>= 1
      end
      res
    end

    n = nums.size
    threshold = Math.sqrt(n).to_i
    small = Hash.new { |h, k| h[k] = [] }

    queries.each do |l, r, k, v|
      if k <= threshold
        small[k] << [l, r, v]
      else
        idx = l
        while idx <= r
          nums[idx] = (nums[idx] * v) % mod
          idx += k
        end
      end
    end

    small.each do |k, list|
      diff = Array.new(n + k + 1, 1)
      list.each do |l, r, v|
        diff[l] = (diff[l] * v) % mod
        inv_v = mod_pow.call(v, mod - 2, mod)
        last_included = r - ((r - l) % k)
        pos = last_included + k
        diff[pos] = (diff[pos] * inv_v) % mod if pos < diff.length
      end

      cur = Array.new(k, 1)
      (0...n).each do |i|
        r = i % k
        cur[r] = (cur[r] * diff[i]) % mod
        nums[i] = (nums[i] * cur[r]) % mod
      end
    end

    nums.reduce(0) { |acc, num| acc ^ num }
  end

  # 3740. Minimum Distance Between Three Equal Elements I
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_distance(nums)
    hash = Hash.new { |h, k| h[k] = [] }
    nums.each_with_index do |num, i|
      hash[num] << i
    end

    res = Float::INFINITY
    hash.each_value do |indices|
      next if indices.size < 3

      (0..(indices.size - 3)).each do |i|
        d = indices[i + 2] - indices[i] + indices[i + 1] - indices[i] + indices[i + 2] - indices[i + 1]
        res = d if d < res
      end
    end
    res == Float::INFINITY ? -1 : res
  end

  # 3741. Minimum Distance Between Three Equal Elements II
  # @param {Integer[]} nums
  # @return {Integer}
  def minimum_distance_ii(nums)
    hash = Hash.new { |h, k| h[k] = [] }
    nums.each_with_index do |num, i|
      hash[num] << i
    end

    res = Float::INFINITY
    hash.each_value do |indices|
      next if indices.size < 3

      (0..(indices.size - 3)).each do |i|
        d = indices[i + 2] - indices[i] + indices[i + 1] - indices[i] + indices[i + 2] - indices[i + 1]
        res = d if d < res
      end
    end
    res == Float::INFINITY ? -1 : res
  end

  # 1320. Minimum Distance to Type a Word Using Two Fingers
  # @param {String} word
  # @return {Integer}
  def minimum_distance(word)
    get_distance = lambda do |p, q|
      x1 = p / 6
      y1 = p % 6
      x2 = q / 6
      y2 = q % 6
      (x1 - x2).abs + (y1 - y2).abs
    end

    n = word.length
    dp = Array.new(n) { Array.new(26) { Array.new(26, Float::INFINITY) } }

    26.times do |i|
      dp[0][i][word[0].ord - "A".ord] = 0
      dp[0][word[0].ord - "A".ord][i] = 0
    end

    (1...n).each do |i|
      cur = word[i].ord - "A".ord
      prev = word[i - 1].ord - "A".ord
      d = get_distance.call(prev, cur)

      26.times do |j|
        dp[i][cur][j] = [dp[i][cur][j], dp[i - 1][prev][j] + d].min
        dp[i][j][cur] = [dp[i][j][cur], dp[i - 1][j][prev] + d].min

        next unless prev == j

        26.times do |k|
          d0 = get_distance.call(k, cur)
          dp[i][cur][j] = [dp[i][cur][j], dp[i - 1][k][j] + d0].min
          dp[i][j][cur] = [dp[i][j][cur], dp[i - 1][j][k] + d0].min
        end
      end
    end

    ans = Float::INFINITY
    26.times do |j|
      26.times do |k|
        ans = [ans, dp[n - 1][j][k]].min
      end
    end
    ans.to_i
  end

  # 1848. Minimum Distance to the Target Element
  # @param {Integer[]} nums
  # @param {Integer} target
  # @param {Integer} start
  # @return {Integer}
  def get_min_distance(nums, target, start)
    n = nums.length
    res = n
    (0...n).each do |i|
      res = [res, (i - start).abs].min if nums[i] === target
    end

    res
  end

  # 2463. Minimum Total Distance Traveled
  # @param {Integer[]} robot
  # @param {Integer[][]} factory
  # @return {Integer}
  def minimum_total_distance(robots, factories)
    robots.sort!
    factories.sort_by! { |f| f[0] }

    factory_positions = []
    factories.each do |factory|
      pos, cap = factory
      cap.times { factory_positions << pos }
    end

    robot_count = robots.size
    factory_count = factory_positions.size

    next_dp = Array.new(factory_count + 1, 0)
    current = Array.new(factory_count + 1, 0)

    current[factory_count] = 1_000_000_000_000

    (robot_count - 1).downto(0) do |i|
      current[factory_count] = 1_000_000_000_000

      (factory_count - 1).downto(0) do |j|
        assign = (robots[i] - factory_positions[j]).abs + next_dp[j + 1]
        skip = current[j + 1]
        current[j] = [assign, skip].min
      end

      (0..factory_count).each do |k|
        next_dp[k] = current[k]
      end
    end

    current[0]
  end

  # 2515. Shortest Distance to Target String in a Circular Array
  # @param {String[]} words
  # @param {String} target
  # @param {Integer} start_index
  # @return {Integer}
  def closest_target(words, target, start_index)
    ans = words.length
    n = words.length

    words.each_with_index do |word, i|
      if word == target
        d = (i - start_index).abs
        ans = [ans, d, n - d].min
      end
    end

    ans < n ? ans : -1
  end

  # 3488. Closest Equal Element Queries
  # @param {Integer[]} nums
  # @param {Integer[]} queries
  # @return {Integer[]}
  def solve_queries(nums, queries)
    n = nums.length
    left = Array.new(n, 0)
    right = Array.new(n, 0)

    pos = {}
    (-n...n).each do |i|
      left[i] = pos.fetch(nums[i], i - n) if i >= 0
      pos[nums[((i % n) + n) % n]] = i
    end

    pos.clear
    ((2 * n) - 1).downto(0) do |i|
      right[i] = pos.fetch(nums[i], i + n) if i < n
      pos[nums[i % n]] = i
    end

    result = []
    queries.each do |x|
      result << if x - left[x] == n
                  -1
                else
                  [x - left[x], right[x] - x].min
                end
    end
    result
  end

  # 3783. Mirror Distance of an Integer
  # @param {Integer} n
  # @return {Integer}
  def mirror_distance(n)
    reverse = n.to_s.reverse.to_i
    (n - reverse).abs
  end

  # 1855. Maximum Distance Between a Pair of Values
  # @param {Integer[]} nums1
  # @param {Integer[]} nums2
  # @return {Integer}
  def max_distance(nums1, nums2)
    i = 0
    j = 0
    max_dist = 0
    while i < nums1.length && j < nums2.length
      if nums1[i] <= nums2[j]
        max_dist = [max_dist, j - i].max
        j += 1
      else
        i += 1
      end
    end
    max_dist
  end
end
