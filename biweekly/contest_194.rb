class Contest194
  # Difference Between Peaks and Valleys
  # @param {Integer[]} nums
  # @return {Integer}
  def peak_valley_difference(nums)
    peak = 0
    valley = 0
    n = nums.length
    (1...n - 1).each do |i|
      peak += nums[i] if nums[i] > nums[i - 1] && nums[i] > nums[i + 1]
      valley += nums[i] if nums[i] < nums[i - 1] && nums[i] < nums[i + 1]
    end

    peak - valley
  end

  # Count Subarrays With Loose Bounds
  # @param {Integer[]} nums
  # @param {Integer} min_k
  # @param {Integer} max_k
  # @return {Integer}
  def count_subarrays(nums, min_k, max_k)
    total = 0
    run = 0

    nums.each do |num|
      if num >= min_k && num <= max_k
        run += 1
        total += run # each new element adds `run` subarrays ending here
      else
        run = 0
      end
    end

    total
  end

  # Count Magical Substring Pairs I
  # @param {String} s
  # @return {Integer}
  def count_magical_pairs(s)
    n = s.length
    codes = s.bytes.map { |b| b - 97 }

    # nxt_same[i] = next index after i holding the same character (nil if none)
    nxt_same = Array.new(n)
    first = Array.new(26) # ends up as first occurrence of each char in s[0..]
    (n - 1).downto(0) do |i|
      c = codes[i]
      nxt_same[i] = first[c]
      first[c] = i
    end

    last = Array.new(26) # last occurrence of each char in s[0..j]
    total = 0

    (0...n - 1).each do |j|
      c = codes[j]
      last[c] = j
      first[c] = nxt_same[j] # s[j] has left the suffix s[j+1..]

      lasts = last.compact.sort.reverse << -1
      firsts = first.compact.sort << n

      (0...[lasts.size, firsts.size].min - 1).each do |t|
        total += (lasts[t] - lasts[t + 1]) * (firsts[t + 1] - firsts[t])
      end
    end

    total
  end
end
