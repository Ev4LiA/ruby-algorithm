class Contest167
  # @param {String} s
  # @return {Boolean}
  def score_balance(s)
    total = 0
    base = "a".ord

    s.each_byte do |byte|
      total += (byte - base) + 1
    end

    (0...s.length).each do |i|
      left += s.get_byte(i) - base + 1
      right = total - left
      return true if left == right
    end

    false
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def longest_subarray(nums)
    return nums.size if nums.size <= 2

    max_len = 2            # any pair is Fibonacci
    cur_len = 2

    (2...nums.size).each do |i|
      if nums[i] == nums[i - 1] + nums[i - 2]
        cur_len += 1
      else
        cur_len = 2        # restart with the last two elements
      end
      max_len = [max_len, cur_len].max
    end

    max_len
  end

  # @param {Integer[][]} points
  # @return {Integer}
  def max_partition_factor(points)
    n = points.size
    return 0 if n == 2

    # pre-compute distances
    dist = Array.new(n) { Array.new(n, 0) }
    max_d = 0
    (0...n).each do |i|
      (i + 1...n).each do |j|
        d = manhattan(points[i], points[j])
        dist[i][j] = dist[j][i] = d
        max_d = d if d > max_d
      end
    end

    low = 0
    high = max_d
    while low < high
      mid = (low + high + 1) / 2
      # build graph with edges < mid
      adj = Array.new(n) { [] }
      (0...n).each do |i|
        (i + 1...n).each do |j|
          if dist[i][j] < mid
            adj[i] << j
            adj[j] << i
          end
        end
      end
      if bipartite?(adj)
        low = mid          # feasible, try larger
      else
        high = mid - 1     # infeasible
      end
    end
    low
  end

  def manhattan(p, q)
    (p[0] - q[0]).abs + (p[1] - q[1]).abs
  end

  def bipartite?(adj)
    n = adj.size
    color = Array.new(n, -1)
    (0...n).each do |i|
      next if color[i] != -1

      color[i] = 0
      stack = [i]
      until stack.empty?
        v = stack.pop
        adj[v].each do |u|
          if color[u] == -1
            color[u] = color[v] ^ 1
            stack << u
          elsif color[u] == color[v]
            return false
          end
        end
      end
    end
    true
  end
end

class ExamTracker
  attr_accessor :times, :prefix

  def initialize
    # times[i] stores the time of the i-th recorded exam (monotonically increasing)
    @times = []
    # prefix[i] = sum of scores of the first i exams (prefix[0] = 0 for convenience)
    @prefix = [0]
  end

  # Records an exam taken at `time` with score `score`.
  # @param time [Integer]
  # @param score [Integer]
  # @return [void]
  def record(time, score)
    @times << time
    @prefix << (@prefix[-1] + score)
    nil
  end

  # Returns total score of exams whose time lies in [start_time, end_time].
  # @param start_time [Integer]
  # @param end_time [Integer]
  # @return [Integer]
  def total_score(start_time, end_time)
    return 0 if @times.empty?

    # first index >= start_time
    left = lower_bound(@times, start_time)
    # first index > end_time
    right_excl = upper_bound(@times, end_time)

    return 0 if left >= right_excl # no exams in range

    # sum of scores in indexes [left, right_excl-1]
    @prefix[right_excl] - @prefix[left]
  end

  private

  # Binary search helpers (lower/upper bound) – O(log n)
  def lower_bound(arr, target)
    l = 0
    r = arr.size
    while l < r
      m = (l + r) >> 1
      if arr[m] < target
        l = m + 1
      else
        r = m
      end
    end
    l
  end

  def upper_bound(arr, target)
    l = 0
    r = arr.size
    while l < r
      m = (l + r) >> 1
      if arr[m] <= target
        l = m + 1
      else
        r = m
      end
    end
    l
  end
end

# Your ExamTracker object will be instantiated and called as such:
# obj = ExamTracker.new()
# obj.record(time, score)
# param_2 = obj.total_score(start_time, end_time)©leetcode
