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
end
