class June2025
  # 2929. Distribute Candies Among Children II
  # @param {Integer} n
  # @param {Integer} limit
  # @return {Integer}
  def distribute_candies(n, limit)
    result = 0
    (0..[limit, n].min).each do |i|
      next if n - i > limit * 2

      result += [n - i, limit].min - [n - i - limit, limit].max + 1
    end
    result
  end

  # 135. Candy
  # @param {Integer[]} ratings
  # @return {Integer}
  def candy(ratings)
    n = ratings.length
    candies = Array.new(n, 1)

    (1...n).each do |i|
      candies[i] = candies[i - 1] + 1 if ratings[i] > ratings[i - 1]
    end

    (n - 2).downto(0) do |i|
      candies[i] = [candies[i], candies[i + 1] + 1].max if ratings[i] > ratings[i + 1]
    end

    candies.sum
  end

  # 1298. Maximum Candies You Can Get from Boxes
  # @param {Integer[]} status
  # @param {Integer[]} candies
  # @param {Integer[][]} keys
  # @param {Integer[][]} contained_boxes
  # @param {Integer[]} initial_boxes
  # @return {Integer}
  def max_candies(status, candies, keys, contained_boxes, initial_boxes)
    n = status.length
    can_open = Array.new(n, false)
    has_box = Array.new(n, false)
    used = Array.new(n, false)
    queue = Queue.new
    total_candies = 0

    (0...n).each do |i|
      can_open[i] = true if status[i] == 1
    end

    initial_boxes.each do |box|
      has_box[box] = true
      next unless can_open[box]

      queue << box
      used[box] = true
      total_candies += candies[box]
    end

    until queue.empty?
      box = queue.shift

      keys[box]&.each do |key|
        can_open[key] = true
        next if used[key] || !has_box[key]

        queue << key
        used[key] = true
        total_candies += candies[key]
      end

      contained_boxes[box]&.each do |contained_box|
        has_box[contained_box] = true
        next if used[contained_box] || !can_open[contained_box]

        queue << contained_box
        used[contained_box] = true
        total_candies += candies[contained_box]
      end
    end

    total_candies
  end

  # 3403. Find the Lexicographically Largest String From the Box I
  # @param {String} word
  # @param {Integer} num_friends
  # @return {String}
  def answer_string(word, num_friends)
    return word if num_friends == 1

    last = last_substring(word)
    n = word.length
    m = last.length

    last[0, [m, n - num_friends + 1].min]
  end

  def last_substring(word)
    n = word.length
    j = 1
    i = 0
    while j < n
      k = 0
      k += 1 while j + k < n && word[i + k] == word[j + k]

      if j + k < n && word[i + k] < word[j + k]
        t = i
        i = j
        j = [j + 1, t + k + 1].max
      else
        j = j + k + 1
      end
    end
    word[i..]
  end

  # 1061. Lexicographically Smallest Equivalent String
  # @param {String} s1
  # @param {String} s2
  # @param {String} base_str
  # @return {String}
  def smallest_equivalent_string(s1, s2, base_str)
    adj = {}
    n = s1.length

    (0...n).each do |i|
      u = s1[i]
      v = s2[i]

      adj[u] ||= []
      adj[u] << v

      adj[v] ||= []
      adj[v] << u
    end

    result = ""

    base_str.chars.each do |char|
      visited = Array.new(26, false)
      result << dfs_1061(char, adj, visited)
    end

    result
  end

  def dfs_1061(char, adj, visited)
    visited[char.ord - "a".ord] = true
    min_char = char

    adj[char]&.each do |neighbor|
      next if visited[neighbor.ord - "a".ord]

      candidate = dfs_1061(neighbor, adj, visited)
      min_char = [min_char, candidate].min
    end

    min_char
  end

  # 2434. Using a Robot to Print the Lexicographically Smallest String
  # @param {String} s
  # @return {String}
  def robot_with_string(s)
    result = ""
    stack = []

    count = Array.new(26, 0)
    s.each_char do |char|
      count[char.ord - "a".ord] += 1
    end

    min_character = "a"
    s.each_char do |char|
      stack << char
      count[char.ord - "a".ord] -= 1
      min_character = (min_character.ord + 1).chr while min_character != "z" && count[min_character.ord - "a".ord].zero?

      result << stack.pop while !stack.empty? && stack.last <= min_character
    end

    result
  end

  # 3170. Lexicographically Minimum String After Removing Stars
  # @param {String} s
  # @return {String}
  def clear_stars(s)
    count = Array.new(26) { Stack.new }

    s.each_char.with_index do |char, i|
      if char == "*"
        count.each do |c|
          next if c.empty?

          j = c.pop
          s[j] = "*"
          break
        end
      else
        count[char.ord - "a".ord] << i
      end
    end

    s.delete("*")
  end

  # 386. Lexicographical Numbers
  # @param {Integer} n
  # @return {Integer[]}
  def lexical_order(n)
    result = []
    (1..9).each do |i|
      generate_lexicographical_numbers(result, i, n)
    end
    result
  end

  def generate_lexicographical_numbers(result, current, n)
    return if current > n

    result << current
    (0..9).each do |i|
      next_number = (current * 10) + i
      break unless next_number <= n

      generate_lexicographical_numbers(result, next_number, n)
    end
  end

  # 440. K-th Smallest in Lexicographical Order
  # @param {Integer} n
  # @param {Integer} k
  # @return {Integer}
  def find_kth_number(n, k)
    curr = 1
    k -= 1
    while k > 0
      step = count_steps(n, curr, curr + 1)
      if step <= k
        curr += 1
        k -= step
      else
        curr *= 10
        k -= 1
      end
    end
    curr
  end

  def count_steps(n, prefix_1, prefix_2)
    steps = 0
    while prefix_1 <= n
      steps += [n + 1, prefix_2].min - prefix_1
      prefix_1 *= 10
      prefix_2 *= 10
    end
    steps
  end

  # 3442. Maximum Difference Between Even and Odd Frequency I
  # @param {String} s
  # @return {Integer}
  def max_difference(s)
    hash = {}
    min_even = 100
    max_odd = 0

    s.each_char do |char|
      hash[char] ||= 0
      hash[char] += 1
    end

    hash.each do |char, count|
      if count.even?
        min_even = [min_even, count].min
      else
        max_odd = [max_odd, count].max
      end
    end

    max_odd - min_even
  end

  # 3445. Maximum Difference Between Even and Odd Frequency II
  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def max_difference_2(s, k)
    n = s.length
    ans = -Float::INFINITY

    ('0'..'4').each do |a|
      ('0'..'4').each do |b|
        next if a == b

        best = Array.new(4, Float::INFINITY)
        cnt_a = 0
        cnt_b = 0
        prev_a = 0
        prev_b = 0
        left = -1

        (0...n).each do |right|
          cnt_a += (s[right] == a) ? 1 : 0
          cnt_b += (s[right] == b) ? 1 : 0

          while right - left >= k && cnt_b - prev_b >= 2
            left_status = get_status(prev_a, prev_b)
            best[left_status] = [best[left_status], prev_a - prev_b].min
            left += 1
            prev_a += (s[left] == a) ? 1 : 0
            prev_b += (s[left] == b) ? 1 : 0
          end

          right_status = get_status(cnt_a, cnt_b)
          if best[right_status ^ 0b10] != Float::INFINITY
            ans = [ans, cnt_a - cnt_b - best[right_status ^ 0b10]].max
          end
        end
      end
    end

    ans
  end

  def get_status(cnt_a, cnt_b)
    ((cnt_a & 1) << 1) | (cnt_b & 1)
  end

  # 3423. Maximum Difference Between Adjacent Elements in a Circular Array
  # @param {Integer[]} nums
  # @return {Integer}
  def max_adjacent_distance(nums)
    n = nums.length
    max_diff = (nums[0] - nums[n - 1]).abs

    (0...n - 1).each do |i|
      max_diff = [max_diff, (nums[i] - nums[i + 1]).abs].max
    end

    max_diff
  end

  # 2616. Minimize the Maximum Difference of Pairs
  # @param {Integer[]} nums
  # @param {Integer} p
  # @return {Integer}
  def minimize_max(nums, p)
    nums.sort!
    left = 0
    right = nums[-1] - nums[0]

    while left < right
      mid = left + (right - left) / 2

      if count_valid_pairs(nums, mid) >= p
        right = mid
      else
        left = mid + 1
      end
    end

    left
  end

  def count_valid_pairs(nums, mid)
    index = 0
    count = 0

    while index < nums.length - 1
      if nums[index + 1] - nums[index] <= mid
        count += 1
        index += 1
      end
      index += 1
    end

    count
  end

  # 2566. Maximum Difference by Remapping a Digit
  # @param {Integer} num
  # @return {Integer}
  def min_max_difference(num)
    max_str = num.to_s
    min_str = max_str.dup
    pos = 0
    while pos < max_str.length && max_str[pos] == "9"
      pos += 1
    end
    max_str.gsub!(max_str[pos], "9") if pos < max_str.length
    min_str.gsub!(min_str[0], "0")

    max_str.to_i - min_str.to_i
  end

  # 1432. Max Difference You Can Get From Changing an Integer
  # @param {Integer} num
  # @return {Integer}
  def max_diff(num)
    min_num = num.to_s
    max_num = min_num.dup

    max_num.each_char do |char|
      if char != '9'
        max_num.gsub!(char, '9')
        break
      end
    end

    min_num.each_char_with_index do |char, i|
      if i == 0
        if char != '1'
          min_num.gsub!(char, '1')
          break
        end
      else
        if char != '0' && char != min_num[0]
          min_num.gsub!(char, '0')
          break
        end
      end
    end
    max_num.to_i - min_num.to_i
  end

  # 2016. Maximum Difference Between Increasing Elements
  # @param {Integer[]} nums
  # @return {Integer}
  def maximum_difference(nums)
    min = nums[0]
    res = -1

    nums.each do |num|
      if num > min
        min = num
      else
        res = [res, num - min].max
      end
    end
    res
  end

  # 3405. Count the Number of Arrays with K Matching Adjacent Elements
  # @param {Integer} n
  # @param {Integer} m
  # @param {Integer} k
  # @return {Integer}
  def count_good_arrays(n, m, k)
    mod = 10 ** 9 + 7
    mx = 100000

    # Initialize factorial and inverse factorial arrays
    fact = Array.new(mx)
    inv_fact = Array.new(mx)

    # Modular exponentiation
    qpow = lambda do |x, n|
      res = 1
      while n > 0
        res = (res * x) % mod if (n & 1) == 1
        x = (x * x) % mod
        n >>= 1
      end
      res
    end

    # Precompute factorials
    fact[0] = 1
    (1...mx).each do |i|
      fact[i] = (fact[i - 1] * i) % mod
    end

    # Precompute inverse factorials
    inv_fact[mx - 1] = qpow.call(fact[mx - 1], mod - 2)
    (mx - 1).downto(1) do |i|
      inv_fact[i - 1] = (inv_fact[i] * i) % mod
    end

    # Combination function
    comb = lambda do |n, m|
      return 0 if m > n || m < 0
      (((fact[n] * inv_fact[m]) % mod) * inv_fact[n - m]) % mod
    end

    # Main calculation
    (((comb.call(n - 1, k) * m) % mod) * qpow.call(m - 1, n - k - 1)) % mod
  end

  # 2966. Divide Array Into Arrays With Max Difference
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer[][]}
  def divide_array(nums, k)
    n = nums.length
    result = []
    nums.sort!

    (0...n - 2).each do |i|
      if i % 3 == 0
        if nums[i + 2] - nums[i] <= k
          result << [nums[i], nums[i + 1], nums[i + 2]]
        else
          return [][]
        end
      end
    end
    result
  end

  # 2294. Partition Array Such That Maximum Difference Is K
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def partition_array(nums, k)
    nums.sort!
    count = 1
    rec = nums[0]

    nums.each do |num|
      if num - rec > k
        count += 1
        rec = num
      end
    end
    count
  end

  # 3443. Maximum Manhattan Distance After K Changes
  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def max_distance(s, k)
    lat = 0
    long = 0
    ans = 0
    s.chars.each_with_index do |char, i|
      if char == "N"
        lat += 1
      elsif char == "S"
        lat -= 1
      elsif char == "E"
        long += 1
      else
        long -= 1
      end
      ans = [ans, [lat.abs + long.abs + k * 2, i + 1].min].max
    end
    ans
  end

  # 3085. Minimum Deletions to Make String K-Special
  # @param {String} word
  # @param {Integer} k
  # @return {Integer}
  def minimum_deletions(word, k)
    hash = {}
    res = word.length
    word.each_char do |char|
      hash[char] ||= 0
      hash[char] += 1
    end

    hash.values.each do |a|
      deleted = 0

      hash.values.each do |b|
        if a > b
          deleted += b
        elsif b > a + k
          deleted += b - (a + k)
        end
      end
      res = [res, deleted].min
    end
    res
  end

  # 2138. Divide a String Into Groups of Size k
  # @param {String} s
  # @param {Integer} k
  # @param {Character} fill
  # @return {String[]}
  def divide_string(s, k, fill)
    result = []
    s.chars.each_slice(k) do |slice|
      result << slice.join + fill * (k - slice.length)
    end
    resultr
  end

  # 2081. Sum of k-Mirror Numbers
  # @param {Integer} k
  # @param {Integer} n
  # @return {Integer}
  def k_mirror(k, n)

  end


  # 2200. Find All K-Distant Indices in an Array
  # @param {Integer[]} nums
  # @param {Integer} key
  # @param {Integer} k
  # @return {Integer[]}
  def find_k_distant_indices(nums, key, k)
    result = []
    r = 0
    n = nums.length
    nums.each_with_index do |num, i|
      if num == key
        l = [r, i - k].max
        r = [n - 1, i + k].min + 1
        result.concat((l...r).to_a)
      end
    end
    result
  end

  # 2040. Kth Smallest Product of Two Sorted Arrays
  # @param {Integer[]} nums1
  # @param {Integer[]} nums2
  # @param {Integer} k
  # @return {Integer}
  def kth_smallest_product(nums1, nums2, k)
    n1 = nums1.length
    n2 = nums2.length
    pos1 = 0
    pos2 = 0

    # Find the position where numbers transition from negative to positive
    while pos1 < n1 && nums1[pos1] < 0
      pos1 += 1
    end

    while pos2 < n2 && nums2[pos2] < 0
      pos2 += 1
    end

    left = -10 ** 10
    right = 10 ** 10

    while left <= right
      mid = (left + right) / 2
      count = 0

      # Case 1: negative * negative = positive
      i1 = 0
      i2 = pos2 - 1
      while i1 < pos1 && i2 >= 0
        if nums1[i1] * nums2[i2] > mid
          i1 += 1
        else
          count += pos1 - i1
          i2 -= 1
        end
      end

      # Case 2: positive * positive = positive
      i1 = pos1
      i2 = n2 - 1
      while i1 < n1 && i2 >= pos2
        if nums1[i1] * nums2[i2] > mid
          i2 -= 1
        else
          count += i2 - pos2 + 1
          i1 += 1
        end
      end

      # Case 3: negative * positive = negative
      i1 = 0
      i2 = pos2
      while i1 < pos1 && i2 < n2
        if nums1[i1] * nums2[i2] > mid
          i2 += 1
        else
          count += n2 - i2
          i1 += 1
        end
      end

      # Case 4: positive * negative = negative
      i1 = pos1
      i2 = 0
      while i1 < n1 && i2 < pos2
        if nums1[i1] * nums2[i2] > mid
          i1 += 1
        else
          count += n1 - i1
          i2 += 1
        end
      end

      if count < k
        left = mid + 1
      else
        right = mid - 1
      end
    end

    left
  end

  # 2311. Longest Binary Subsequence Less Than or Equal to K
  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def longest_subsequence(s, k)
    sum = 0
    count = 0
    bits = (Math.log(k) / Math.log(2)).to_i + 1

    s.each_char.with_index do |_, i|
      ch = s[s.length - i - 1]
      if ch == '1'
        if i < bits && sum + (1 << i) <= k
          sum += 1 << i
          count += 1
        end
      else
        count += 1
      end
    end
    count
  end

  # 2099. Find Subsequence of Length K With the Largest Sum
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer[]}
  def max_subsequence(nums, k)
    n = nums.length
    vals = Array.new(n) { Array.new(2) }

    (0...n).each do |i|
      vals[i][0] = i
      vals[i][1] = nums[i]
    end

    vals.sort! { |x1, x2| x2[1] <=> x1[1] }

    vals[0, k] = vals[0, k].sort { |x1, x2| x1[0] <=> x2[0] }

    res = Array.new(k)
    (0...k).each do |i|
      res[i] = vals[i][1]
    end

    res
  end

  # 1498. Number of Subsequences That Satisfy the Given Sum Condition
  # @param {Integer[]} nums
  # @param {Integer} target
  # @return {Integer}
  def num_subseq(nums, target)
    nums.sort!
    n = nums.length
    mod = 10 ** 9 + 7
    pow = Array.new(n, 1)
    (1...n).each do |i|
      pow[i] = (pow[i - 1] * 2) % mod
    end


    count = 0
    left = 0
    right = n - 1
    while left <= right
      if nums[left] + nums[right] > target
        right -= 1
      else
        count = (count + pow[right - left]) % mod
        left += 1
      end
    end
    count
  end
end
