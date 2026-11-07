class November2026
  # 453. Minimum Moves to Equal Array Elements
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves(nums)
    nums.sum - (nums.min * nums.size)
  end

  # 462. Minimum Moves to Equal Array Elements II
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves2(nums)
    nums.sort!
    median = nums[nums.size / 2]
    nums.sum { |x| (x - median).abs }
  end

  # 3736. Minimum Moves to Equal Array Elements III
  # @param {Integer[]} nums
  # @return {Integer}
  def min_moves3(nums)
    max = nums.max
    (max * nums.size) - nums.sum
  end

  # 3505. Minimum Operations to Make Elements Within K Subarrays Equal
  # @param {Integer[]} nums
  # @param {Integer} x
  # @param {Integer} k
  # @return {Integer}
  def min_operations(nums, x, k); end

  # 1385. Find the Distance Value Between Two Arrays
  # @param {Integer[]} arr1
  # @param {Integer[]} arr2
  # @param {Integer} d
  # @return {Integer}
  def find_the_distance_value(arr1, arr2, d)
    arr2 = arr2.sort!
    cnt = 0
    arr1.each do |x|
      p = binary_search(arr2, x)
      ok = true
      ok &&= (arr2[p] - x > d) if p < arr2.length

      ok &&= (x - arr2[p - 1] > d) if p - 1 >= 0 && p - 1 <= arr2.length

      cnt += (ok ? 1 : 0)
    end

    cnt
  end

  def binary_search(arr, target)
    low = 0
    high = arr.size - 1
    return high + 1 if arr[high] < target

    while low < high
      mid = ((high - low) / 2) + low
      if arr[mid] < target
        low = mid + 1
      else
        high = mid
      end
    end
    low
  end

  # 2747. Count Zero Request Servers
  # @param {Integer} n
  # @param {Integer[][]} logs
  # @param {Integer} x
  # @param {Integer[]} queries
  # @return {Integer[]}
  def count_servers(n, logs, x, queries)
    logs.sort_by! { |_, t| t }
    order = (0...queries.size).sort_by { |i| queries[i] }

    cnt = Array.new(n + 1, 0)
    ans = Array.new(queries.size)
    active = 0
    left = right = 0
    m = logs.size

    order.each do |i|
      q = queries[i]

      # Add logs with time <= q
      while right < m && logs[right][1] <= q
        s = logs[right][0]
        active += 1 if cnt[s] == 0
        cnt[s] += 1
        right += 1
      end

      # Remove logs with time < q - x
      while left < right && logs[left][1] < q - x
        s = logs[left][0]
        cnt[s] -= 1
        active -= 1 if cnt[s] == 0
        left += 1
      end

      ans[i] = n - active
    end

    ans
  end

  # 1882. Process Tasks Using Servers
  # @param {Integer[]} servers
  # @param {Integer[]} tasks
  # @return {Integer[]}
  def assign_tasks(servers, tasks)
    n = servers.size
    free = MinHeap.new   # key = weight * n + index
    busy = MinHeap.new   # key = free_time * n + index
    servers.each_with_index { |w, i| free.push(w * n + i) }

    ans = Array.new(tasks.size)
    time = 0

    tasks.each_with_index do |d, j|
      time = j if time < j

      # If nothing is free, jump ahead to when the next server frees up
      time = busy.top / n if free.empty?

      # Release every server that is free by `time`
      while !busy.empty? && busy.top / n <= time
        i = busy.pop % n
        free.push(servers[i] * n + i)
      end

      i = free.pop % n
      ans[j] = i
      busy.push((time + d) * n + i)
    end

    ans
  end

  # Binary min-heap over plain integers (stands in for Java's PriorityQueue)
  class MinHeap
    def initialize
      @a = []
    end

    def empty?
      @a.empty?
    end

    def top
      @a[0]
    end

    def push(x)
      a = @a
      a << x
      i = a.size - 1
      while i > 0
        p = (i - 1) >> 1
        break if a[p] <= a[i]

        a[p], a[i] = a[i], a[p]
        i = p
      end
    end

    def pop
      a = @a
      top = a[0]
      last = a.pop
      unless a.empty?
        a[0] = last
        i = 0
        n = a.size
        loop do
          l = 2 * i + 1
          break if l >= n

          r = l + 1
          c = (r < n && a[r] < a[l]) ? r : l
          break if a[i] <= a[c]

          a[i], a[c] = a[c], a[i]
          i = c
        end
      end
      top
    end
  end
end
