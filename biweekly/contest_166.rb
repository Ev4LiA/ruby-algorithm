require "set"

class Contest166
  # @param {String} s
  # @return {String}
  def majority_frequency_group(s)
    char_freq = s.chars.tally

    freq_to_char = {}
    char_freq.each do |char, freq|
      freq_to_char[freq] ||= []
      freq_to_char[freq] << char
    end

    max_length = 0
    best_freq = 0
    freq_to_char.each do |freq, chars|
      if chars.size > max_length || (chars.size == max_length && freq > best_freq)
        max_length = chars.size
        best_freq = freq
      end
    end

    freq_to_char[best_freq].join
  end

  # @param {Integer} n
  # @param {Integer[]} costs
  # @return {Integer}
  def climb_stairs(n, costs)
    # dp[i] represents minimum cost to reach step i
    dp = Array.new(n + 1, Float::INFINITY)
    dp[0] = 0 # Starting at step 0 with cost 0

    (0...n).each do |i|
      next if dp[i] == Float::INFINITY # Skip unreachable steps

      # Try jumping to i+1, i+2, i+3
      [1, 2, 3].each do |jump|
        next_step = i + jump
        next if next_step > n # Don't go beyond step n

        # Cost = costs[next_step] + (next_step - i)²
        cost = costs[next_step - 1] + ((next_step - i)**2) # costs is 1-indexed
        dp[next_step] = [dp[next_step], dp[i] + cost].min
      end
    end

    dp[n]
  end

  # @param {String} s
  # @param {Integer} k
  # @return {Integer}
  def distinct_points(s, k)
    n = s.length
    distinct_coords = Set.new

    # Calculate total displacement
    total_x = total_y = 0
    s.each_char do |move|
      case move
      when "U" then total_y += 1
      when "D" then total_y -= 1
      when "L" then total_x -= 1
      when "R" then total_x += 1
      end
    end

    # Calculate prefix sums for sliding window
    prefix_x = Array.new(n + 1, 0)
    prefix_y = Array.new(n + 1, 0)

    s.each_char.with_index do |move, i|
      prefix_x[i + 1] = prefix_x[i]
      prefix_y[i + 1] = prefix_y[i]

      case move
      when "U" then prefix_y[i + 1] += 1
      when "D" then prefix_y[i + 1] -= 1
      when "L" then prefix_x[i + 1] -= 1
      when "R" then prefix_x[i + 1] += 1
      end
    end

    # Try removing each substring of length k
    (0..n - k).each do |i|
      # Displacement of the removed substring [i, i+k-1]
      removed_x = prefix_x[i + k] - prefix_x[i]
      removed_y = prefix_y[i + k] - prefix_y[i]

      # Final position = total - removed
      final_x = total_x - removed_x
      final_y = total_y - removed_y

      distinct_coords.add([final_x, final_y])
    end

    distinct_coords.size
  end

  # @param {Integer[]} nums
  # @param {Integer[][]} swaps
  # @return {Integer}
  def max_alternating_sum(nums, swaps)
    n = nums.length

    # Union-Find to group indices that can be swapped
    parent = (0...n).to_a

    find = lambda do |x|
      parent[x] = find.call(parent[x]) if parent[x] != x
      parent[x]
    end

    union = lambda do |x, y|
      px = find.call(x)
      py = find.call(y)
      parent[px] = py if px != py
    end

    # Build connected components
    swaps.each { |a, b| union.call(a, b) }

    # Group indices by their root parent
    groups = Hash.new { |h, k| h[k] = [] }
    (0...n).each { |i| groups[find.call(i)] << i }

    result = 0

    groups.each do |_root, indices|
      # Get values that can be rearranged freely within this group
      values = indices.map { |i| nums[i] }.sort.reverse

      # Count even and odd positions in this group
      even_count = indices.count { |i| i.even? }
      odd_count = indices.length - even_count

      # Optimally assign values: largest to even positions, smallest to odd
      values.each_with_index do |val, idx|
        if idx < even_count
          result += val  # Assign to even position (positive contribution)
        else
          result -= val  # Assign to odd position (negative contribution)
        end
      end
    end

    result
  end
end
