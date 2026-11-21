class Contest196
  # @param {Integer[]} rain
  # @return {String[]}
  def assign_umbrella(rain)
    n = rain.length
    alice = 0
    bob = 0
    answer = Array.new(n)

    n.times do |i|
      # Alice wants it on the first day of a rainy pair
      alice_needs = i + 1 < n && rain[i] == 1 && rain[i + 1] == 1
      bob_needs = rain[i] == 1

      if alice_needs && bob_needs
        if alice <= bob
          answer[i] = "Alice"
          alice += 1
        else
          answer[i] = "Bob"
          bob += 1
        end
      elsif alice_needs
        answer[i] = "Alice"
        alice += 1
      elsif bob_needs
        answer[i] = "Bob"
        bob += 1
      else
        answer[i] = "None"
      end
    end

    answer
  end

  # Minimum Range After Sum Operations
  # @param {Integer} a
  # @param {Integer} b
  # @param {Integer} c
  # @return {Integer}
  def min_range(a, b, c)
    lo, mid, hi = [a, b, c].sort

    # Replacing hi with lo + mid gives (lo, mid, lo + mid), range == mid.
    # Every other move leaves hi - lo or worse, and from there hi -> lo + mid
    # is a fixed point, so the best reachable range is min(hi - lo, mid).
    [hi - lo, mid].min
  end

  # Minimum Operations to Make a Mountain Array
  # @param {Integer[]} nums
  # @return {Integer}
  def min_mountain_operations(nums)
    n = nums.length
    return -1 if n < 3

    # Any target value can be kept at or below max + n: a strict run of at most
    # n values starting from nums[i] <= max never needs to climb higher.
    cap = nums.max + n
    inf = 1 << 60

    # up[i][v] = cheapest way to make nums[0..i] strictly increasing with nums[i] = v
    up = Array.new(n)
    n.times do |i|
      cur = Array.new(cap + 1, inf)
      if i.zero?
        (1..cap).each { |v| cur[v] = (nums[0] - v).abs }
      else
        prev = up[i - 1]
        best = inf # min(prev[1..v-1])
        (1..cap).each do |v|
          best = prev[v - 1] if prev[v - 1] < best
          cur[v] = (nums[i] - v).abs + best
        end
      end
      up[i] = cur
    end

    # Sweep the peak candidates right to left, keeping only the suffix row:
    # down[v] = cheapest way to make nums[i..n-1] strictly decreasing with nums[i] = v
    ans = inf
    down = nil
    (n - 1).downto(1) do |i|
      cur = Array.new(cap + 1, inf)
      if down.nil?
        (1..cap).each { |v| cur[v] = (nums[i] - v).abs }
      else
        best = inf
        (1..cap).each do |v|
          best = down[v - 1] if down[v - 1] < best
          cur[v] = (nums[i] - v).abs + best
        end
      end

      if i <= n - 2
        left = up[i]
        (1..cap).each do |v|
          # the peak value v is paid for once, in both halves
          total = left[v] + cur[v] - (nums[i] - v).abs
          ans = total if total < ans
        end
      end

      down = cur
    end

    ans >= inf ? -1 : ans
  end
end
