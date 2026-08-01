class Contest188
  # Q1. Count Valid Prefixes
  # @param {String} s
  # @return {Integer}
  def count_valid_prefixes(s)
    zeros = 0
    ones = 0
    count = 0
    s.each_char do |c|
      c == "0" ? zeros += 1 : ones += 1
      count += 1 if (zeros - ones).abs <= 1
    end
    count
  end

  # Q2. Widest Possible Fence
  # @param {Integer[]} planks
  # @return {Integer}
  def maximum_width(planks)
    # Count how many planks exist at each height.
    freq = Hash.new(0)
    planks.each { |p| freq[p] += 1 }

    heights = freq.keys

    # For each target height h, accumulate how many planks we can make at h.
    # Start with planks already at height h (used as-is).
    width = Hash.new(0)
    heights.each { |a| width[a] = freq[a] }

    # Distinct-height pairs a < b: target a+b gains min(freq[a], freq[b]) combined planks.
    heights.each_with_index do |a, i|
      heights.each_with_index do |b, j|
        next unless j > i

        target = a + b
        width[target] += [freq[a], freq[b]].min
      end
    end

    # Same-height pairs: two planks of height x form one plank of height 2x.
    heights.each do |x|
      pairs = freq[x] / 2
      width[2 * x] += pairs if pairs > 0
    end

    best = 1  # a single plank is always a valid fence
    width.each_value { |w| best = w if w > best }
    best
  end
end
