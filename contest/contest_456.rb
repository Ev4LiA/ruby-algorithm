require 'set'

class Contest456
  # @param {String} s
  # @return {String[]}
  def partition_string(s)
    seen = Set.new
    result = []
    current = ""

    s.each_char do |char|
      current += char
      # If current segment is unique (not seen before)
      unless seen.include?(current)
        result << current
        seen << current
        current = ""  # Start new segment
      end
      # If seen before, continue building current segment
    end

    result
  end

  # @param {String[]} words
  # @return {Integer[]}
  def longest_common_prefix(words)
    n = words.length
    return [0] if n <= 1

    # Helper method to compute common prefix length between two strings
    def common_prefix_length(s1, s2)
      len = 0
      min_len = [s1.length, s2.length].min
      (0...min_len).each do |i|
        if s1[i] == s2[i]
          len += 1
        else
          break
        end
      end
      len
    end

    # Precompute common prefix lengths for adjacent pairs
    adjacent_prefixes = []
    (0...n-1).each do |i|
      adjacent_prefixes[i] = common_prefix_length(words[i], words[i+1])
    end

    # Precompute common prefix lengths for pairs with one element gap
    gap_prefixes = []
    (0...n-2).each do |i|
      gap_prefixes[i] = common_prefix_length(words[i], words[i+2])
    end

    # Precompute prefix and suffix maximums for efficient range queries
    # prefix_max[i] = max of adjacent_prefixes[0..i]
    # suffix_max[i] = max of adjacent_prefixes[i..n-2]
    prefix_max = Array.new(n-1, 0)
    suffix_max = Array.new(n-1, 0)

    prefix_max[0] = adjacent_prefixes[0]
    (1...n-1).each do |i|
      prefix_max[i] = [prefix_max[i-1], adjacent_prefixes[i]].max
    end

    suffix_max[n-2] = adjacent_prefixes[n-2]
    (n-3).downto(0) do |i|
      suffix_max[i] = [suffix_max[i+1], adjacent_prefixes[i]].max
    end

    result = []

    (0...n).each do |remove_idx|
      max_prefix = 0

      if remove_idx == 0
        # Remove first element: use pairs (1,2), (2,3), ..., (n-2,n-1)
        max_prefix = suffix_max[1] if n > 2
      elsif remove_idx == n - 1
        # Remove last element: use pairs (0,1), (1,2), ..., (n-3,n-2)
        max_prefix = prefix_max[n-3] if n > 2
      else
        # Remove middle element
        # Use pairs before remove_idx-1 and after remove_idx
        max_before = remove_idx > 1 ? prefix_max[remove_idx-2] : 0
        max_after = remove_idx < n-2 ? suffix_max[remove_idx+1] : 0
        new_pair = gap_prefixes[remove_idx-1] # pair (remove_idx-1, remove_idx+1)

        max_prefix = [max_before, max_after, new_pair].max
      end

      result << max_prefix
    end

    result
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def min_xor(nums, k)
    n = nums.length

    # Prefix XOR array: px[i] = XOR of nums[0] to nums[i-1]
    px = Array.new(n + 1, 0)
    (0...n).each do |i|
      px[i + 1] = px[i] ^ nums[i]
    end

    # dp[i][j] = minimum possible maximum XOR when partitioning nums[0...i] into j subarrays
    inf = Float::INFINITY
    dp = Array.new(n + 1) { Array.new(k + 1, inf) }
    dp[0][0] = 0

    (1..k).each do |j|
      (j..n).each do |i|
        (j - 1...i).each do |t|
          next if dp[t][j - 1] == inf
          x = px[i] ^ px[t]
          dp[i][j] = [dp[i][j], [dp[t][j - 1], x].max].min
        end
      end
    end

    dp[n][k]
  end
end
