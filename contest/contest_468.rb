class Contest468
  # @param {Integer[]} nums
  # @return {Integer}
  def even_number_bitwise_o_rs(nums)
    res = 0
    nums.each do |num|
      res |= num if num.even?
    end
    res
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def max_total_value(nums, k)
    return 0 if k.zero? || nums.empty?

    diff = nums.max - nums.min
    diff * k
  end

  # @param {Integer[]} nums1
  # @param {Integer[]} nums2
  # @return {Integer}
  # Breadth-first search over all permutations reachable by one split-and-merge.
  # n ≤ 6 so factorial state-space (≤ 720) is tiny.
  def min_split_merge(nums1, nums2)
    return 0 if nums1 == nums2

    n = nums1.length
    target = nums2.freeze

    start_key = nums1.join(",")
    target_key = target.join(",")

    visited = { start_key => 0 }
    queue = [[nums1, 0]]

    until queue.empty?
      arr, steps = queue.shift

      # generate all arrays obtainable in one move
      (0...n).each do |l|
        (l...n).each do |r|
          segment = arr[l..r]
          remaining = arr[0...l] + arr[r + 1..]

          (0..remaining.length).each do |pos|
            next if pos == l # reinserting at same position changes nothing

            new_arr = remaining.dup
            new_arr.insert(pos, *segment)

            key = new_arr.join(",")
            next if visited.key?(key)

            return steps + 1 if key == target_key

            visited[key] = steps + 1
            queue << [new_arr, steps + 1]
          end
        end
      end
    end

    # Should always be reachable due to permutation constraint
    -1
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def max_total_value2(nums, k)
    n = nums.length
    return 0 if k.zero? || n.zero?

    # Precompute logs
    log = Array.new(n + 1, 0)
    (2..n).each { |i| log[i] = log[i >> 1] + 1 }

    max_log = log[n]
    max_sp = Array.new(max_log + 1) { Array.new(n) }
    min_sp = Array.new(max_log + 1) { Array.new(n) }

    # Level 0
    (0...n).each do |i|
      max_sp[0][i] = nums[i]
      min_sp[0][i] = nums[i]
    end

    # Build sparse tables
    (1..max_log).each do |k|
      span = 1 << (k - 1)
      (0...n - (1 << k) + 1).each do |i|
        max_sp[k][i] = [max_sp[k - 1][i], max_sp[k - 1][i + span]].max
        min_sp[k][i] = [min_sp[k - 1][i], min_sp[k - 1][i + span]].min
      end
    end

    range_diff = lambda do |l, r|
      len = r - l + 1
      j = log[len]
      mx = [max_sp[j][l], max_sp[j][r - (1 << j) + 1]].max
      mn = [min_sp[j][l], min_sp[j][r - (1 << j) + 1]].min
      mx - mn
    end

    # Max-heap via Ruby's Array with negated value because default is min-heap when using sort etc.
    heap = []
    push = lambda do |diff, l, r|
      heap << [-diff, l, r]
      i = heap.size - 1
      while i > 0
        parent = (i - 1) >> 1
        break if heap[parent][0] <= heap[i][0]
        heap[parent], heap[i] = heap[i], heap[parent]
        i = parent
      end
    end

    pop = lambda do
      return nil if heap.empty?
      top = heap[0]
      last = heap.pop
      if !heap.empty?
        heap[0] = last
        i = 0
        size = heap.size
        loop do
          lchild = i * 2 + 1
          break if lchild >= size
          rchild = lchild + 1
          smallest = lchild
          smallest = rchild if rchild < size && heap[rchild][0] < heap[lchild][0]
          break if heap[i][0] <= heap[smallest][0]
          heap[i], heap[smallest] = heap[smallest], heap[i]
          i = smallest
        end
      end
      top
    end

    # Initialize heap with subarrays ending at n-1 for each start index
    (0...n).each do |l|
      diff = range_diff.call(l, n - 1)
      push.call(diff, l, n - 1)
    end

    result = 0
    cnt = 0

    while cnt < k && (node = pop.call)
      diff_neg, l, r = node
      diff = -diff_neg
      result += diff
      cnt += 1
      if r - 1 >= l
        diff2 = range_diff.call(l, r - 1)
        push.call(diff2, l, r - 1)
      end
    end

    result
  end
end
