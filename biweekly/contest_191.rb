class Contest191
  # @param {Integer[]} nums
  # @return {Integer}
  def count_special_integers(nums)
    # Map value -> list of indices where it appears
    positions = Hash.new { |h, k| h[k] = [] }

    nums.each_with_index do |val, idx|
      positions[val] << idx
    end

    special_count = 0

    positions.each_value do |idxs|
      # Must appear exactly 3 times
      next unless idxs.length == 3

      # Check equally spaced: i2 - i1 == i3 - i2
      i1, i2, i3 = idxs
      special_count += 1 if (i2 - i1) == (i3 - i2)
    end

    special_count
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def count_special_integers_ii(nums)
    # Map value -> list of indices where it appears
    positions = Hash.new { |h, k| h[k] = [] }

    nums.each_with_index do |val, idx|
      positions[val] << idx
    end

    special_count = 0

    positions.each_value do |idxs|
      # Must appear at least 3 times
      next if idxs.length < 3

      # Check that all consecutive gaps are the same
      diff = idxs[1] - idxs[0]
      ok = true

      (2...idxs.length).each do |i|
        if idxs[i] - idxs[i - 1] != diff
          ok = false
          break
        end
      end

      special_count += 1 if ok
    end

    special_count
  end

  # Q3. Minimum Days to Score Exactly N Points
  # @param {Integer} n
  # @return {Integer}
  def min_days(n)
    # We will try all possible maximum streak lengths k
    # and compute the minimal days for each, then take the minimum.
    best = Float::INFINITY

    # Upper bound for k: sum 1..k = k*(k+1)/2 <= n  => k ~ O(sqrt(n))
    k = 1
    while k * (k + 1) / 2 <= n
      full = n / k       # number of full streaks of length k
      rem  = n % k       # remainder points to be covered by a last partial streak

      # Days:
      # - full streaks: full * k days of earning
      # - skips between full streaks: (full - 1) skips if full >= 1
      # - last partial streak: rem days if rem > 0
      days = full * k
      days += [full - 1, 0].max
      days += rem if rem > 0

      best = [best, days].min
      k += 1
    end

    best.to_i
  end
end
