class Contest512
  # Largest Integer With Given Digit Sum
  # @param {Integer} n
  # @param {Integer} s
  # @return {Integer}
  def largest_integer(n, s)
    return 0 if s.zero?
    return -1 if s > 9 * n

    digits = []
    remaining = s
    n.times do
      d = [remaining, 9].min
      digits << d
      remaining -= d
    end

    digits.join.to_i
  end

  # Aggregate Two Time Series
  # @param {Integer[][]} series1
  # @param {Integer[][]} series2
  # @return {Integer[][]}
  # @param {Integer[][]} series1
  # @param {Integer[][]} series2
  # @return {Integer[][]}
  def aggregate_time_series(series1, series2)
    # value contributed by a series at timestamp t:
    # the value of the first entry with timestamp >= t, else 0
    value_at = lambda do |series, t|
      lo = 0
      hi = series.length
      while lo < hi
        mid = (lo + hi) / 2
        if series[mid][0] < t
          lo = mid + 1
        else
          hi = mid
        end
      end
      lo < series.length ? series[lo][1] : 0
    end

    timestamps = (series1.map(&:first) + series2.map(&:first)).uniq.sort

    timestamps.map do |t|
      [t, value_at.call(series1, t) + value_at.call(series2, t)]
    end
  end

  # Count Valid Sequences
  MOD = 1_000_000_007

  # @param {Integer} n
  # @param {Integer} k
  # @return {Integer}
  def count_valid_sequences(n, k)
    max = n + 5
    fact = Array.new(max)
    inv_fact = Array.new(max)
    fact[0] = 1
    (1...max).each { |i| fact[i] = fact[i - 1] * i % MOD }
    inv_fact[max - 1] = fact[max - 1].pow(MOD - 2, MOD)
    (max - 2).downto(0) { |i| inv_fact[i] = inv_fact[i + 1] * (i + 1) % MOD }

    comb = lambda do |a, b|
      next 0 if b < 0 || b > a || a < 0

      fact[a] * inv_fact[b] % MOD * inv_fact[a - b] % MOD
    end

    total = comb.call(n - 1, k - 1)

    odd = 0
    if (n - k) >= 0 && (n - k).even?
      m = (n - k) / 2
      odd = comb.call(m + k - 1, k - 1)
    end

    (total - odd) % MOD
  end
end

