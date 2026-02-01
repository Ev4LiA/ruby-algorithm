class Contest487
  # @param {Integer} n
  # @return {Integer}
  # Monobit: all bits same. That's 0 and (2^k - 1) for k>=1.
  # Count = 1 + max k such that 2^k - 1 <= n  =>  k <= log2(n+1).
  def count_monobit(n)
    return 1 if n.zero?

    1 + Math.log2(n + 1).floor
  end

  # @param {Integer[]} nums
  # @return {Integer}
  # With m elements, current player can remove any subarray of length < m,
  # so they can remove m-1 elements and leave one. The single remaining
  # element must be an end of the current array. Alice (first move) can
  # leave either nums[0] (remove 1..n-1) or nums[-1] (remove 0..n-2),
  # so she picks the larger: max(nums[0], nums[-1]).
  def final_element(nums)
    return nums[0] if nums.size == 1

    [nums[0], nums[-1]].max
  end
end
