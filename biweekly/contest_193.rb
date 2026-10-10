class Contest193
  # Q1. Maximum Product Pair With Target Sum
  # @param {Integer[]} nums
  # @param {Integer} target
  # @return {Integer[]}
  def max_product_pair(nums, target)
    best = [-1, -1]
    best_product = nil

    nums.each_with_index do |a, i|
      nums.each_with_index do |b, j|
        next if i == j
        # enforce nums[i] > nums[j] and the target sum
        next unless a > b && a + b == target

        product = a * b
        if best_product.nil? || product > best_product
          best_product = product
          best = [i, j]
        end
      end
    end

    best
  end

  # Q2. Longest Resilient Subarray I
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def resilient_subarray(nums, k)
    best = 1
    run_start = 0

    (0...nums.length).each do |i|
      # extend the current run while residues mod k stay equal
      run_start = i if i > 0 && nums[i] % k != nums[i - 1] % k

      r = nums[i] % k
      m = i - run_start + 1 # current run length ending at i

      if r == 0
        len = m
      else
        d = k / nums[i].gcd(k) # L-1 must be a multiple of d
        len = (((m - 1) / d) * d) + 1 # largest valid L within the run
      end

      best = len if len > best
    end

    best
  end
end
