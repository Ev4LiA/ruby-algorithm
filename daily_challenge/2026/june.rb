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

  # 1840. Maximum Building Height
  # @param {Integer} n
  # @param {Integer[][]} restrictions
  # @return {Integer}
  def max_building(n, restrictions)
    # Ensure building 1 is present with height 0
    restrictions << [1, 0]

    # If building n is not restricted, its max possible is n - 1
    restrictions << [n, n - 1] unless restrictions.any? { |id, _h| id == n }

    # Sort by building index
    restrictions.sort_by! { |id, _h| id }

    # Left-to-right pass to enforce slope constraint from the left
    (1...restrictions.length).each do |i|
      prev_id, prev_h = restrictions[i - 1]
      cur_id, cur_h   = restrictions[i]
      dist = cur_id - prev_id
      # cannot be higher than prev_h + dist
      max_from_left = prev_h + dist
      restrictions[i][1] = max_from_left if cur_h > max_from_left
    end

    # Right-to-left pass to enforce slope constraint from the right
    (restrictions.length - 2).downto(0) do |i|
      next_id, next_h = restrictions[i + 1]
      cur_id, cur_h   = restrictions[i]
      dist = next_id - cur_id
      # cannot be higher than next_h + dist
      max_from_right = next_h + dist
      restrictions[i][1] = max_from_right if cur_h > max_from_right
    end

    # Now compute maximum possible height between each consecutive pair
    max_height = 0

    (1...restrictions.length).each do |i|
      id1, h1 = restrictions[i - 1]
      id2, h2 = restrictions[i]
      dist = id2 - id1
      # Max peak you can get in this segment
      segment_peak = (h1 + h2 + dist) / 2
      max_height = [max_height, segment_peak].max
    end

    max_height
  end

  # 1833. Maximum Ice Cream Bars
  # @param {Integer[]} costs
  # @param {Integer} coins
  # @return {Integer}
  def max_ice_cream(costs, coins)
    # Constraints say costs[i] <= 1e5, so we can use counting sort
    max_cost = costs.max
    counts = Array.new(max_cost + 1, 0)

    # Frequency of each cost
    costs.each do |c|
      counts[c] += 1
    end

    bought = 0

    # Greedily buy from cheapest to most expensive
    (1..max_cost).each do |price|
      break if coins < price

      next unless counts[price] > 0

      # How many of this price can we buy with remaining coins?
      can_buy = [counts[price], coins / price].min
      bought += can_buy
      coins  -= can_buy * price
    end

    bought
  end

  # 1189. Maximum Number of Balloons
  # @param {String} text
  # @return {Integer}
  def max_number_of_balloons(text)
    needed = {
      "b" => 1,
      "a" => 1,
      "l" => 2,
      "o" => 2,
      "n" => 1
    }

    freq = Hash.new(0)
    text.each_char { |ch| freq[ch] += 1 }

    # For each required character, compute how many times it supports "balloon"
    needed.map { |ch, cnt| freq[ch] / cnt }.min
  end

  # 3699. Number of ZigZag Arrays I
  # @param {Integer} n
  # @param {Integer} l
  # @param {Integer} r
  # @return {Integer}
  def zig_zag_arrays(n, l, r)
    mod = 1_000_000_007

    # We keep original value range [l, r] and index arrays by value.
    dp0  = Array.new(r + 1, 0)  # last step is decreasing (dir = 0)
    dp1  = Array.new(r + 1, 0)  # last step is increasing (dir = 1)
    sum0 = Array.new(r + 2, 0)  # prefix sums for dp0
    sum1 = Array.new(r + 2, 0)  # prefix sums for dp1

    # Base: sequences of length 1, each value in [l, r] has exactly 1 sequence
    (l..r).each do |x|
      dp0[x] = 1
      dp1[x] = 1
      # prefix sum over [l, x]
      offset = x - l + 1
      sum0[x] = offset
      sum1[x] = offset
    end

    # Build sequences from length 2 to n using rolling arrays
    (1...n).each do
      # Transition using prefix sums from previous layer
      (l..r).each do |j|
        # dp[i][0][j] = sum_{k=j+1..r} dp[i-1][1][k]
        dp0[j] = (sum1[r] - sum1[j] + mod) % mod
        # dp[i][1][j] = sum_{k=l..j-1} dp[i-1][0][k]
        dp1[j] = sum0[j - 1] % mod
      end

      # Rebuild prefix sums for current dp0, dp1
      sum0[l] = dp0[l] % mod
      sum1[l] = dp1[l] % mod

      (l + 1..r).each do |j|
        sum0[j] = (sum0[j - 1] + dp0[j]) % mod
        sum1[j] = (sum1[j - 1] + dp1[j]) % mod
      end
    end

    (sum0[r] + sum1[r]) % mod
  end

  # 1967. Number of Strings That Appear as Substrings in Word
  # @param {String[]} patterns
  # @param {String} word
  # @return {Integer}
  def num_of_strings(patterns, word)
    res = 0
    patterns.each do |pat|
      res += 1 if word.include?(pat)
    end

    res
  end
end
