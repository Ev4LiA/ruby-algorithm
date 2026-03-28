require "set"

class Contest179
  # @param {Integer[]} nums
  # @return {Integer}
  def min_absolute_difference(nums)
    indices_of_ones = []
    indices_of_twos = []

    nums.each_with_index do |num, index|
      if num == 1
        indices_of_ones << index
      elsif num == 2
        indices_of_twos << index
      end
    end

    return -1 if indices_of_ones.empty? || indices_of_twos.empty?

    min_diff = Float::INFINITY

    indices_of_ones.each do |idx1|
      indices_of_twos.each do |idx2|
        min_diff = [min_diff, (idx1 - idx2).abs].min
      end
    end

    min_diff.to_i
  end

  # @param {Integer} n
  # @param {Integer} pos
  # @param {Integer} k
  # @return {Integer}
  def count_visible_people(n, _pos, k)
    mod = (10**9) + 7

    return 2 if n == 1 && k.zero?

    # We need to calculate C(n-1, k) * 2
    # C(n, k) = n! / (k! * (n-k)!)
    # We can precompute factorials and their modular inverses.

    fact = Array.new(n + 1)
    inv_fact = Array.new(n + 1)
    fact[0] = 1
    inv_fact[0] = 1

    (1..n).each do |i|
      fact[i] = (fact[i - 1] * i) % mod
    end

    inv_fact[n] = fact[n].pow(mod - 2, mod)
    (n - 1).downto(1) do |i|
      inv_fact[i] = (inv_fact[i + 1] * (i + 1)) % mod
    end

    combinations_val = combinations(n - 1, k, mod, fact, inv_fact)
    (2 * combinations_val) % mod
  end

  # @param {Integer[][]} grid
  # @return {Integer}
  def min_cost(grid)
    m = grid.length
    n = grid[0].length

    dp = Array.new(n) { Set.new }

    dp[0].add(grid[0][0])
    (1...n).each do |j|
      dp[j].add(dp[j - 1].first ^ grid[0][j])
    end

    (1...m).each do |i|
      dp[0] = Set[dp[0].first ^ grid[i][0]]
      (1...n).each do |j|
        merged_set = dp[j].union(dp[j - 1])
        dp[j] = merged_set.map { |xor_sum| xor_sum ^ grid[i][j] }.to_set
      end
    end

    dp[n - 1].min
  end

  private

  def combinations(n, k, mod, fact, inv_fact)
    return 0 if k.negative? || k > n

    numerator = fact[n]
    denominator = (inv_fact[k] * inv_fact[n - k]) % mod
    (numerator * denominator) % mod
  end
end
