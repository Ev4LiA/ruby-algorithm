class July2025
  # 3330. Find the Original Typed String I
  # @param {String} word
  # @return {Integer}
  def possible_string_count(word)
    res = 1
    n = word.length
    (1...n).each do |i|
      res += 1 if word[i] == word[i - 1]
    end
    res
  end

  # 3333. Find the Original Typed String II
  # @param {String} word
  # @param {Integer} k
  # @return {Integer}
  def possible_string_count_2(word, k); end

  # 3304. Find the K-th Character in String Game I
  # @param {Integer} k
  # @return {Character}
  def kth_character(k)
    ans = 0

    # Move up the implicit binary tree until reaching the root (1).
    while k != 1
      t = k.bit_length - 1            # highest bit index (0-based)
      t -= 1 if (1 << t) == k         # ensure 2^t < k
      k -= (1 << t)
      ans += 1
    end

    ("a".ord + ans).chr
  end

  # 3334. Find the K-th Character in String Game II
  # @param {Integer} k
  # @param {Integer[]} operations
  # @return {Character}
  def kth_character_2(k, operations)
    ans = 0

    # Traverse from node k back to root (1) in the implicit binary tree.
    # Each step subtracts the highest power of two strictly less than the current k.
    # Whenever the corresponding entry in operations is non-zero, we advance the letter by one.
    while k != 1
      t = k.bit_length - 1            # floor(log2(k))
      t -= 1 if (1 << t) == k         # ensure 2^t < k
      k -= (1 << t)
      ans += 1 if operations[t].to_i != 0
    end

    ("a".ord + (ans % 26)).chr
  end

  # 1394. Find Lucky Integer in an Array
  # @param {Integer[]} arr
  # @return {Integer}
  def find_lucky(arr)
    arr.sort!
    res = -1
    count = 1
    n = arr.length
    (1...n).each do |i|
      if arr[i] == arr[i - 1]
        count += 1
      else
        res = [res, count].max if count == arr[i - 1]
        count = 1
      end
    end

    res = [res, count].max if count == arr[n - 1]
    res
  end
end

class FindSumPairs
  def initialize(nums1, nums2)
    @nums1 = nums1
    @nums2 = nums2
    @count_2 = {}

    @nums2.each.with_index do |num, _i|
      @count_2[num] ||= 0
      @count_2[num] += 1
    end
  end

  def add(index, val)
    @count_2[@nums2[index]] -= 1
    @nums2[index] += val
    @count_2[@nums2[index]] ||= 0
    @count_2[@nums2[index]] += 1
  end

  def count(tot)
    res = 0
    @nums1.each do |num|
      res += @count_2[tot - num] || 0
    end
    res
  end

  # 1353. Maximum Number of Events That Can Be Attended
  # @param {Integer[][]} events
  # @return {Integer}
  def max_events(events)
    n = events.length
    return 0 if n.zero?

    # Determine the latest day any event ends
    max_day = events.max_by { |e| e[1] }[1]

    # Sort events by start day
    events.sort_by! { |e| e[0] }

    heap = MinHeap.new
    ans = 0
    j = 0

    (1..max_day).each do |day|
      # Add all events that start on or before this day
      while j < n && events[j][0] <= day
        heap.push(events[j][1])
        j += 1
      end

      # Remove events that have already ended
      heap.pop while !heap.empty? && heap.min < day

      # Attend the event that ends earliest (top of min-heap)
      unless heap.empty?
        heap.pop
        ans += 1
      end
    end
    ans
  end

  # 1751. Maximum Number of Events That Can Be Attended II
  # @param {Integer[][]} events
  # @param {Integer} k
  # @return {Integer}
  def max_value(events, k)
    events.sort_by! { |e| e[0] }
    n = events.length
    # outer dimension = remaining picks (0..k), inner = current event index
    dp = Array.new(k + 1) { Array.new(n, -1) }
    dfs(0, k, events, dp)
  end

  def dfs(cur_index, count, events, dp)
    return 0 if count == 0 || cur_index == events.length

    return dp[count][cur_index] if dp[count][cur_index] != -1

    # Option 1: skip current event
    skip = dfs(cur_index + 1, count, events, dp)

    # Option 2: take current event and jump to the first non-overlapping one
    next_index =
      events.bsearch_index { |e| e[0] > events[cur_index][1] } || events.length
    take = events[cur_index][2] + dfs(next_index, count - 1, events, dp)

    dp[count][cur_index] = [skip, take].max
  end

  # 3439. Reschedule Meetings for Maximum Free Time I
  # @param {Integer} event_time
  # @param {Integer} k
  # @param {Integer[]} start_time
  # @param {Integer[]} end_time
  # @return {Integer}
  def max_free_time(event_time, k, start_time, end_time)
    n = start_time.length
    res = 0
    sum = Array.new(n + 1, 0)
    (0...n).each do |i|
      sum[i + 1] = sum[i] + (end_time[i] - start_time[i])
    end

    (k - 1...n).each do |i|
      right = i == n - 1 ? event_time : start_time[i + 1]
      left = i == k - 1 ? 0 : end_time[i - k]
      res = [res, right - left - (sum[i + 1] - sum[i - k + 1])].max
    end
    res
  end

  # 1900. The Earliest and Latest Rounds Where Players Compete
  # @param {Integer} n
  # @param {Integer} first_player
  # @param {Integer} second_player
  # @return {Integer[]}
  def earliest_and_latest(n, first_player, second_player)
    # Ensure first_player comes before second_player to leverage symmetry.
    first_player, second_player = second_player, first_player if first_player > second_player

    # Lazy initialisation of memo tables. The problem constraints guarantee n ≤ 30.
    @F ||= Array.new(31) { Array.new(31) { Array.new(31, 0) } }
    @G ||= Array.new(31) { Array.new(31) { Array.new(31, 0) } }

    _dp_earliest_latest(n, first_player, second_player)
  end

  # --------------------------------------------------------------------------
  # Helper: memoised DP translating the original Java logic one-to-one.
  # Returns [earliest_round, latest_round] that the players f and s meet when
  # there are n players remaining.
  # --------------------------------------------------------------------------
  def _dp_earliest_latest(n, f, s)
    # Return cached result if present.
    return [@F[n][f][s], @G[n][f][s]] if @F[n][f][s] != 0

    # Base case: the two players meet this round.
    if f + s == n + 1
      @F[n][f][s] = 1
      @G[n][f][s] = 1
      return [1, 1]
    end

    # Exploit symmetry when the two players are on opposite halves.
    if f + s > n + 1
      res = _dp_earliest_latest(n, n + 1 - s, n + 1 - f)
      @F[n][f][s], @G[n][f][s] = res
      return res
    end

    earliest = Float::INFINITY
    latest   = -Float::INFINITY

    n_half = (n + 1) / 2 # Number of players that advance to the next round.

    if s <= n_half
      # Both players remain in the left (front) half after this round.
      (0...f).each do |i|
        (0...(s - f)).each do |j|
          res = _dp_earliest_latest(n_half, i + 1, i + j + 2)
          earliest = [earliest, res[0]].min
          latest   = [latest,   res[1]].max
        end
      end
    else
      # second_player lies in the right half.
      s_prime = n + 1 - s
      mid     = (n - (2 * s_prime) + 1) / 2

      (0...f).each do |i|
        (0...(s_prime - f)).each do |j|
          res = _dp_earliest_latest(n_half, i + 1, i + j + mid + 2)
          earliest = [earliest, res[0]].min
          latest   = [latest,   res[1]].max
        end
      end
    end

    @F[n][f][s] = earliest + 1
    @G[n][f][s] = latest + 1
    [@F[n][f][s], @G[n][f][s]]
  end

  # 2410. Maximum Matching of Players With Trainers
  # @param {Integer[]} players
  # @param {Integer[]} trainers
  # @return {Integer}
  def match_players_and_trainers(players, trainers)
    players.sort!
    trainers.sort!
    res = 0
    i = 0
    j = 0
    while i < players.length && j < trainers.length
      if players[i] <= trainers[j]
        res += 1
        i += 1
        j += 1
      else
        j += 1
      end
    end
    res
  end

  # 1290. Convert Binary Number in a Linked List to Integer
  # Definition for singly-linked list.
  # class ListNode
  #     attr_accessor :val, :next
  #     def initialize(val = 0, _next = nil)
  #         @val = val
  #         @next = _next
  #     end
  # end
  # @param {ListNode} head
  # @return {Integer}
  def get_decimal_value(head)
    res = 0
    while head
      res = (res * 2) + head.val.to_i
      head = head.next
    end
    res
  end

  # 3136. Valid Word
  # @param {String} word
  # @return {Boolean}
  def is_valid(word)
    n = word.length
    return false unless n >= 3

    has_vowel = false
    has_consonant = false

    word.each_char do |c|
      if /[A-Za-z]/.match?(c)
        if /[aeiou]/.match?(c.downcase)
          has_vowel = true
        else
          has_consonant = true
        end
      elsif !/[0-9]/.match?(c)
        return false
      end
    end
    has_vowel && has_consonant
  end

  # 3201. Find the Maximum Length of Valid Subsequence I
  # @param {Integer[]} nums
  # @return {Integer}
  def maximum_length(nums)
    res = 0
    patterns = [[0, 0], [0, 1], [1, 0], [1, 1]]

    patterns.each do |pattern|
      count = 0
      nums.each do |num|
        count += 1 if num % 2 == pattern[count % 2]
      end
      res = [res, count].max
    end
    res
  end

  # 3202. Find the Maximum Length of Valid Subsequence II
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  # def maximum_length2(nums, k); end

  # 1957. Delete Characters to Make Fancy String
  # @param {String} s
  # @return {String}
  def make_fancy_string(s)
    res = ""
    return s if s.length < 3

    res += s[0..1]

    (2...s.length).each do |i|
      res += s[i] if s[i] != res[res.length - 1] || s[i] != res[res.length - 2]
    end
    res
  end

  # 1695. Maximum Erasure Value
  # @param {Integer[]} nums
  # @return {Integer}
  def maximum_unique_subarray(nums)
    n = nums.length
    seen = []
    left = 0
    current_sum = 0
    max_sum = 0

    (0...n).each do |right|
      while seen[nums[right]]
        current_sum -= nums[left]
        seen[nums[left]] = false
        left += 1
      end

      seen[nums[right]] = true
      current_sum += nums[right]
      max_sum = [max_sum, current_sum].max
    end
    max_sum
  end

  # 2411. Smallest Subarrays With Maximum Bitwise OR
  # @param {Integer[]} nums
  # @return {Integer[]}
  def smallest_subarrays(nums)
    n = nums.length
    bit_index = Array.new(31) { -1 }
    ans = Array.new(n)

    (0...n).reverse_each do |i|
      j = i
      31.times do |bit|
        if (nums[i] & (1 << bit)).zero?
          j = [j, bit_index[bit]].max if bit_index[bit] != -1
        else
          bit_index[bit] = i
        end
      end

      ans[i] = j - i + 1
    end
    ans
  end
end
