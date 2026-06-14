class June2026
  # 2144. Minimum Cost of Buying Candies With Discount
  # @param {Integer[]} cost
  # @return {Integer}
  def minimum_cost(cost)
    cost.sort!.reverse!
    sum = 0
    count = 0
    cost.each do |num|
      if count < 2
        sum += num
        count += 1
      else
        count = 0
      end
    end

    sum
  end

  # 3633. Earliest Finish Time for Land and Water Rides I
  # @param {Integer[]} land_start_time
  # @param {Integer[]} land_duration
  # @param {Integer[]} water_start_time
  # @param {Integer[]} water_duration
  # @return {Integer}
  def earliest_finish_time(land_start_time, land_duration, water_start_time, water_duration)
    n = land_start_time.length
    m = water_start_time.length

    res = Float::INFINITY

    (0...n).each do |i|
      (0...m).each do |j|
        # land first, then water
        land_finish = land_start_time[i] + land_duration[i]
        land_then_water = [land_finish, water_start_time[j]].max + water_duration[j]
        res = [res, land_then_water].min

        # water first, then land
        water_finish = water_start_time[j] + water_duration[j]
        water_then_land = [water_finish, land_start_time[i]].max + land_duration[i]
        res = [res, water_then_land].min
      end
    end

    res
  end

  # 3635. Earliest Finish Time for Land and Water Rides II
  # @param {Integer[]} land_start_time
  # @param {Integer[]} land_duration
  # @param {Integer[]} water_start_time
  # @param {Integer[]} water_duration
  # @return {Integer}
  def earliest_finish_time(land_start_time, land_duration, water_start_time, water_duration)
    ans1 = best_order(land_start_time, land_duration, water_start_time, water_duration)
    ans2 = best_order(water_start_time, water_duration, land_start_time, land_duration)
    [ans1, ans2].min
  end

  # first_* : list we do first
  # second_* : list we do second
  def best_order(first_start, first_dur, second_start, second_dur)
    n2 = second_start.length

    # sort second rides by start time
    rides2 = (0...n2).map { |i| [second_start[i], second_dur[i]] }
    rides2.sort_by! { |s, _d| s }

    s2 = Array.new(n2)
    d2 = Array.new(n2)
    n2.times do |i|
      s2[i], d2[i] = rides2[i]
    end

    # prefix minimum of duration
    pref_min_d = Array.new(n2)
    cur = Float::INFINITY
    n2.times do |i|
      cur = [cur, d2[i]].min
      pref_min_d[i] = cur
    end

    # suffix minimum of (start + duration)
    suff_min_finish = Array.new(n2 + 1, Float::INFINITY)
    (n2 - 1).downto(0) do |i|
      finish = s2[i] + d2[i]
      suff_min_finish[i] = [finish, suff_min_finish[i + 1]].min
    end

    ans = Float::INFINITY

    first_start.length.times do |i|
      finish1 = first_start[i] + first_dur[i]

      # upper_bound on s2: first index with start > finish1
      idx = upper_bound(s2, finish1)

      cand = Float::INFINITY
      # case 1: start second ride immediately if it already opened
      cand = [cand, finish1 + pref_min_d[idx - 1]].min if idx > 0
      # case 2: wait for some later-opening second ride
      cand = [cand, suff_min_finish[idx]].min if idx < n2

      ans = [ans, cand].min
    end

    ans
  end

  def upper_bound(arr, target)
    lo = 0
    hi = arr.length
    while lo < hi
      mid = (lo + hi) / 2
      if arr[mid] <= target
        lo = mid + 1
      else
        hi = mid
      end
    end
    lo
  end

  # 2574. Left and Right Sum Differences
  # @param {Integer[]} nums
  # @return {Integer[]}
  def left_right_difference(nums)
    n = nums.length
    ans = []

    left_sum = 0
    nums.each_with_index do |num, i|
      ans[i] = left_sum
      left_sum += num
    end

    right_sum = 0

    (0...n).reverse_each do |i|
      ans[i] = (ans[i] - right_sum).abs
      right_sum += nums[i]
    end

    ans
  end

  # 2196. Create Binary Tree From Descriptions
  # Definition for a binary tree node.
  # class TreeNode
  #   attr_accessor :val, :left, :right
  #   def initialize(val = 0, left = nil, right = nil)
  #     @val = val
  #     @left = left
  #     @right = right
  #   end
  # end

  # @param {Integer[][]} descriptions
  # @return {TreeNode}
  def create_binary_tree(descriptions)
    # Map value -> TreeNode
    nodes = {}
    # Set of all values that appear as children
    children = {}

    descriptions.each do |parent_val, child_val, is_left|
      parent = (nodes[parent_val] ||= TreeNode.new(parent_val))
      child  = (nodes[child_val]  ||= TreeNode.new(child_val))

      if is_left == 1
        parent.left = child
      else
        parent.right = child
      end

      children[child_val] = true
    end

    # Root is the node that never appears as a child
    root_val = nil
    descriptions.each do |parent_val, _child_val, _is_left|
      unless children[parent_val]
        root_val = parent_val
        break
      end
    end

    nodes[root_val]
  end

  # 2130. Maximum Twin Sum of a Linked List
  # Definition for singly-linked list.
  # class ListNode
  #   attr_accessor :val, :next
  #   def initialize(val = 0, _next = nil)
  #     @val = val
  #     @next = _next
  #   end
  # end

  # @param {ListNode} head
  # @return {Integer}
  def pair_sum(head)
    # 1. Find middle using fast / slow  
    slow = head
    fast = head
    while fast && fast.next
      slow = slow.next
      fast = fast.next.next
    end

    # 2. Reverse second half starting from slow
    prev = nil
    curr = slow
    while curr
      nxt = curr.next
      curr.next = prev
      prev = curr
      curr = nxt
    end
    second = prev

    # 3. Walk both halves, compute twin sums, track max
    max_sum = 0
    first = head
    while second
      sum = first.val + second.val
      max_sum = sum if sum > max_sum
      first = first.next
      second = second.next
    end

    max_sum
  end
end
