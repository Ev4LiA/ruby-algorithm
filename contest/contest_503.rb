class Contest503
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer[]}
  def limit_occurrences(nums, k)
    counts = Hash.new(0)
    result = []

    nums.each do |x|
      if counts[x] < k
        result << x
        counts[x] += 1
      end
    end

    result
  end

  # @param {String} password
  # @return {Integer}
  def password_strength(password)
    strength = 0
    password.chars.uniq.each do |c|
      strength += case c
                  when "a".."z" then 1
                  when "A".."Z" then 2
                  when "0".."9" then 3
                  when *'!@#$'.chars then 5
                  else 0
                  end
    end

    strength
  end

  def min_operations(nums)
    n = nums.length
    target = (0...n).to_a
    return 0 if nums == target

    # Find the rotation offset: nums rotated left by k == target
    # means nums[k] == 0, and nums[k + i] == i for all i
    check_rotation = lambda do |arr|
      k = arr.index(0)
      return k if arr.each_with_index.all? { |v, i| v == (i - k) % n }

      nil
    end

    # Check rotations of nums (cost = k rotations)
    if (k = check_rotation.call(nums))
      return k
    end

    # Check rotations of reversed nums (cost = 1 reverse + k rotations)
    if (k = check_rotation.call(nums.reverse))
      return 1 + k
    end

    -1
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def min_operations(nums)
    n = nums.length
    return 0 if nums == (0...n).to_a

    check_rotation = lambda do |arr|
      k = arr.index(0)
      return nil unless arr.each_with_index.all? { |v, i| v == (i - k) % n }

      k
    end

    if (k = check_rotation.call(nums))
      return k
    end

    if (k = check_rotation.call(nums.reverse))
      return 1 + [k, (n - k) % n].min
    end

    -1
  end
end
