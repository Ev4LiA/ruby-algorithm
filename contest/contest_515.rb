class Contest515
  # Nearest Available Drone
  # @param {Integer[][]} drones
  # @param {Integer[]} target
  # @return {Integer}
  def nearest_drone(drones, target)
    tx, ty = target
    best_idx = -1
    best_dist = Float::INFINITY

    drones.each_with_index do |(x, y, range), i|
      dist = (x - tx).abs + (y - ty).abs
      next if dist > range          # unreachable

      if dist < best_dist           # strictly smaller keeps the earlier index on ties
        best_dist = dist
        best_idx = i
      end
    end

    best_idx
  end

  # Minimize the Maximum Waiting Time at Synchronized Traffic Lights
  # @param {Integer} period
  # @param {Integer[]} lights
  # @param {Integer[]} arrival_time
  # @return {Integer}
  def min_penalty(period, lights, arrival_time)
    max_light = lights.max
    penalty = 0

    arrival_time.each do |t|
      r = t % period
      # Assign to the light with the largest green window.
      # Wait is 0 if that window still covers r; otherwise period - r.
      wait = r < max_light ? 0 : period - r
      penalty = wait if wait > penalty
    end

    penalty
  end

  # Maximum Gap Between Stations
  # @param {String} skill
  # @param {String} station
  # @return {Integer}
  def maximum_gap(skill, station)
    n = skill.length
    m = station.length
    return 0 if n == 1

    s = skill.bytes
    t = station.bytes

    # left[i]: earliest station index for worker i, packing 0..i from the left
    left = Array.new(n)
    j = 0
    n.times do |i|
      j += 1 while j < m && t[j] != s[i]
      left[i] = j
      j += 1
    end

    # right[i]: latest station index for worker i, packing i..n-1 from the right
    right = Array.new(n)
    j = m - 1
    (n - 1).downto(0) do |i|
      j -= 1 while j >= 0 && t[j] != s[i]
      right[i] = j
      j -= 1
    end

    best = 0
    (1...n).each do |i|
      gap = right[i] - left[i - 1]
      best = gap if gap > best
    end
    best
  end
end
