class Contest_176
  # @param {String[]} words
  # @param {Integer[]} weights
  # @return {String}
  def map_word_weights(words, weights)
    res = ""
    words.each do |word|
      weight = word.chars.reduce(0) { |sum, char| sum + weights[char.ord - "a".ord] }

      mapped_char = ("z".ord - (weight % 26)).chr
      res += mapped_char
    end
    res
  end

  # @param {String[]} words
  # @param {Integer[]} weights
  # @return {String}
  def map_word_weights_to_chars(words, weights)
    result = ""
    words.each do |word|
      word_weight = 0
      word.each_char do |char|
        char_index = char.ord - "a".ord
        word_weight += weights[char_index]
      end

      mapped_value = word_weight % 26
      # Map 0 -> 'z', 1 -> 'y', ..., 25 -> 'a'
      mapped_char = ("z".ord - mapped_value).chr
      result += mapped_char
    end
    result
  end

  # @param {String[]} words
  # @param {Integer} k
  # @return {Integer}
  def count_prefix_connected_groups(words, k)
    prefix_counts = Hash.new(0)

    words.each do |word|
      if word.length >= k
        prefix = word[0...k]
        prefix_counts[prefix] += 1
      end
    end

    connected_groups = 0
    prefix_counts.each do |_prefix, count|
      connected_groups += 1 if count >= 2
    end

    connected_groups
  end

  # @param {Integer[]} nums
  # @param {Integer[]} colors
  # @return {Integer}
  def maximum_robbery(nums, colors)
    n = nums.length
    return 0 if n == 0
    return nums[0] if n == 1

    # DP state:
    # prev_skip: max money robbed up to previous house, skipping it
    # prev_rob: max money robbed up to previous house, robbing it
    prev_skip = 0
    prev_rob = nums[0]

    (1...n).each do |i|
      # max money from previous step, regardless of robbing or skipping
      max_at_prev = [prev_skip, prev_rob].max

      # current amount if we skip house i
      curr_skip = max_at_prev

      # current amount if we rob house i
      curr_rob = if colors[i] == colors[i - 1]
                   # Must have skipped i-1 to rob i
                   nums[i] + prev_skip
                 else
                   # Can rob i even if i-1 was robbed
                   nums[i] + max_at_prev
                 end

      # update states for next iteration
      prev_skip = curr_skip
      prev_rob = curr_rob
    end

    [prev_skip, prev_rob].max
  end
end
