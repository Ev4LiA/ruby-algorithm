class Contest466
  # @param {Integer[]} nums
  # @return {Integer}
  def min_operations_nums(nums)
    # If all elements are already equal, no operation needed.
    # Otherwise, selecting the whole array once suffices because
    # the bitwise AND of all elements applied across the array makes
    # every element equal to that AND result.
    nums.uniq.length == 1 ? 0 : 1
  end

  # @param {String} s
  # @return {Integer}
  def min_operations_string(s)
    max_distance = 0

    s.each_byte do |byte|
      # Calculate distance to 'a' when only allowed to increment cyclically.
      # For 'a' distance = 0, for 'z' distance = 1, ..., for 'b' distance = 25.
      diff = byte - 97 # 'a'.ord == 97
      distance = (26 - diff) % 26

      max_distance = distance if distance > max_distance
      # Early exit – distance cannot exceed 25.
      break if max_distance == 25
    end

    max_distance
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def bowl_subarrays(nums)
    n = nums.length
    return 0 if n < 3

    # next greater element to right
    ngr = Array.new(n, n)
    stack = []
    n.times do |i|
      ngr[stack.pop] = i while !stack.empty? && nums[i] > nums[stack[-1]]
      stack << i
    end

    # next greater element to left
    ngl = Array.new(n, -1)
    stack.clear
    (n - 1).downto(0) do |i|
      ngl[stack.pop] = i while !stack.empty? && nums[i] > nums[stack[-1]]
      stack << i
    end

    count = 0
    n.times do |i|
      j = ngr[i]
      count += 1 if j < n && (j - i) >= 2
    end

    n.times do |i|
      j = ngl[i]
      count += 1 if j >= 0 && (i - j) >= 2
    end

    count
  end

  # @param {Integer} n
  # @return {Integer}
  def count_binary_palindromes(n)
    return 1 if n.zero? # only 0
    return 2 if n == 1 # only 1

    bin_n = n.to_s(2)
    len_n = bin_n.length

    total = 0

    # Length 1 separately includes 0 and 1
    total += 2 # "0" and "1"

    # Count lengths 2 .. len_n-1
    (2...len_n).each do |len|
      half_len = (len + 1) / 2
      total += 1 << (half_len - 1) # first bit of half fixed to 1
    end

    # Now handle palindromes of length len_n
    half_len = (len_n + 1) / 2
    prefix_bits = bin_n[0, half_len]
    prefix_val = prefix_bits.to_i(2)

    # starting prefix value (leading bit 1) for len_n >=2, else 0
    start_val = len_n == 1 ? 0 : (1 << (half_len - 1))

    # Count full prefixes strictly less than prefix_val
    total += prefix_val - start_val if prefix_val > start_val

    # Build palindrome from prefix_val itself and include if <= n
    palindrome = build_palindrome(prefix_val, len_n)
    total += 1 if palindrome <= n

    total
  end

  private

  # Helper to build palindrome integer given prefix and total length.
  def build_palindrome(prefix, length)
    bits = prefix.to_s(2).rjust((length + 1) / 2, '0')
    mirror = bits[0, length / 2].reverse
    (bits + mirror).to_i(2)
  end
end
