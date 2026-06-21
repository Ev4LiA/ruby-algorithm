# Simple binary min-heap priority queue for [distance, state]
class MinHeap
  def initialize
    @data = []
  end

  def empty?
    @data.empty?
  end

  def push(item)
    @data << item
    sift_up(@data.length - 1)
  end

  def pop
    return nil if @data.empty?

    top = @data[0]
    last = @data.pop
    unless @data.empty?
      @data[0] = last
      sift_down(0)
    end
    top
  end

  private

  def sift_up(idx)
    while idx > 0
      parent = (idx - 1) / 2
      break if @data[parent][0] <= @data[idx][0]

      @data[parent], @data[idx] = @data[idx], @data[parent]
      idx = parent
    end
  end

  def sift_down(idx)
    n = @data.length
    loop do
      left = (idx * 2) + 1
      right = (idx * 2) + 2
      smallest = idx

      smallest = left if left < n && @data[left][0] < @data[smallest][0]
      smallest = right if right < n && @data[right][0] < @data[smallest][0]

      break if smallest == idx

      @data[smallest], @data[idx] = @data[idx], @data[smallest]
      idx = smallest
    end
  end
end

class Contest507
  # @param {String} moves
  # @return {Integer}
  def max_distance(moves)
    x = 0
    y = 0
    k = 0

    moves.each_char do |ch|
      case ch
      when "U" then y += 1
      when "D" then y -= 1
      when "L" then x -= 1
      when "R" then x += 1
      when "_" then k += 1
      end
    end

    (x.abs + y.abs + k)
  end

  # @param {Integer[]} nums
  # @param {Integer} x
  # @return {Integer}
  def count_valid_subarrays(nums, x)
    n = nums.length
    prefix = Array.new(n + 1, 0)

    # prefix[i] = sum of nums[0...i]
    (0...n).each do |i|
      prefix[i + 1] = prefix[i] + nums[i]
    end

    ans = 0

    (0...n).each do |l|
      (l...n).each do |r|
        sum = prefix[r + 1] - prefix[l]

        last_digit = sum % 10
        next unless last_digit == x

        first_digit = sum
        first_digit /= 10 while first_digit >= 10

        ans += 1 if first_digit == x
      end
    end

    ans
  end

  # shortest_path.rb

  # @param {Integer} n
  # @param {Integer[][]} edges
  # @param {String} labels
  # @param {Integer} k
  # @return {Integer}
  def shortest_path(n, edges, labels, k)
    # Build adjacency list: graph[u] = [[v, w], ...]
    graph = Array.new(n) { [] }
    edges.each do |u, v, w|
      graph[u] << [v, w]
    end

    # Distances: key = [node, last_char, run_len], value = best distance
    dist = {}

    heap = MinHeap.new
    start_char = labels[0]
    start_state = [0, start_char, 1]
    dist[start_state] = 0
    heap.push([0, start_state])

    until heap.empty?
      cur_dist, (u, last_char, run_len) = heap.pop

      # Skip outdated heap entries
      next if dist[[u, last_char, run_len]] != cur_dist

      # Explore neighbors
      graph[u].each do |v, w|
        next_char = labels[v]

        if next_char == last_char
          new_run = run_len + 1
          next if new_run > k
        else
          new_run = 1
        end

        new_state = [v, next_char, new_run]
        new_dist = cur_dist + w

        if !dist.key?(new_state) || new_dist < dist[new_state]
          dist[new_state] = new_dist
          heap.push([new_dist, new_state])
        end
      end
    end

    # Among all states ending at node n - 1, pick minimal distance
    ans = 1 << 60
    dist.each do |(node, _ch, _run), d|
      ans = d if node == n - 1 && d < ans
    end

    ans == 1 << 60 ? -1 : ans
  end
end
