# @param {Integer[]} nums
# @param {Integer} target
# @return {Boolean}
def can_partition(nums, target)
  # Calculate total product of all numbers
  total_product = nums.reduce(:*)

  # If total product is not target^2, partition is impossible
  return false if total_product != target * target

  n = nums.length

  # Try all possible non-empty proper subsets using bit manipulation
  # Range (1...(1 << n) - 1) excludes empty set and full set
  (1...(1 << n) - 1).each do |mask|
    subset_product = 1

    # Calculate product of current subset
    nums.each_with_index do |num, i|
      subset_product *= num if (mask & (1 << i)) != 0
    end

    # If this subset has product target,
    # the remaining subset automatically has product target
    return true if subset_product == target
  end

  false
end

# Test cases
puts can_partition([3, 1, 6, 8, 4], 24) # true
puts can_partition([2, 5, 3, 7], 15) # false

# Additional test cases
puts can_partition([1, 1, 1, 1], 1)     # true
puts can_partition([2, 2, 2, 2], 4)     # true
puts can_partition([1, 2, 3, 6], 6)     # true
