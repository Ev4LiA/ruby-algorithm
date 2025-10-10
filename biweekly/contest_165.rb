# rubocop:disable Lint/RedundantRequireStatement
require "set"
# rubocop:enable Lint/RedundantRequireStatement

class Contest165
  # @param {Integer[]} nums
  # @return {Integer}
  def smallest_absent(nums)
    avg = nums.sum.to_f / nums.length
    present = nums.to_set
    candidate = avg.floor + 1
    candidate = 1 if candidate < 1
    candidate += 1 while present.include?(candidate)
    candidate
  end

  # @param {Integer[]} arrivals
  # @param {Integer} w
  # @param {Integer} m
  # @return {Integer}
  def min_arrivals_to_discard(arrivals, w, m)
    # Sliding window over days, tracking only KEPT items.
    discarded = 0
    counts = Hash.new(0)           # current kept count per type inside window
    window = []                    # queue: [day, type] for kept items

    arrivals.each_with_index do |type, idx|
      day = idx + 1                # convert to 1-based day index

      # shrink window left bound so that it includes only days >= day - w + 1
      window_start = day - w + 1
      while !window.empty? && window.first[0] < window_start
        _old_day, old_type = window.shift
        counts[old_type] -= 1
        counts.delete(old_type) if counts[old_type].zero?
      end

      if counts[type] < m
        # keep this arrival
        counts[type] += 1
        window << [day, type]
      else
        # must discard
        discarded += 1
      end
    end

    discarded
  end

  # @param {Integer} n
  # @return {Integer[][]}
  def generate_schedule(n)
    # Quick impossibility checks based on empirical small n analysis
    return [] if n < 5 # n = 2,3,4 cannot satisfy the "no consecutive days" constraint

    matches = []
    n.times do |i|
      n.times do |j|
        next if i == j

        matches << [i, j] # i = home, j = away
      end
    end

    max_attempts = 2000
    rng_seed_base = 42
    attempt = 0

    while attempt < max_attempts
      rng = Random.new(rng_seed_base + attempt)
      remaining = matches.shuffle(random: rng)
      schedule = []
      last_teams = Set.new
      success = true

      until remaining.empty?
        idx = remaining.index { |m| !last_teams.include?(m[0]) && !last_teams.include?(m[1]) }
        if idx.nil?
          success = false
          break
        end
        match = remaining.delete_at(idx)
        schedule << match
        last_teams = match.to_set
      end

      return schedule if success

      attempt += 1
    end

    # If all attempts failed, return empty array as per the problem statement
    []
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def max_xor_subsequences(nums)
    basis = Array.new(31, 0) # for bits 0..30 (since 10^9 < 2^30)

    nums.each do |num|
      x = num
      (30).downto(0) do |bit|
        next if (x & (1 << bit)).zero?

        if basis[bit].zero?
          basis[bit] = x
          break
        else
          x ^= basis[bit]
        end
      end
    end

    # Construct maximum xor
    res = 0
    (30).downto(0) do |bit|
      res = [res, res ^ basis[bit]].max
    end

    res
  end
end
