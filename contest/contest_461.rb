class Contest461
  # @param {Integer[]} nums
  # @return {Boolean}
  def is_trionic(nums)
    n = nums.length
    return false if n < 3

    i = 0

    # 1) Strictly increasing to peak (index p)
    i += 1 while i + 1 < n && nums[i] < nums[i + 1]

    # Peak cannot be first element and there must be at least two elements left
    return false if i == 0 || i >= n - 2

    # 2) Strictly decreasing to valley (index q)
    i += 1 while i + 1 < n && nums[i] > nums[i + 1]

    # Valley index q must not be last element
    return false if i >= n - 1

    # 3) Strictly increasing to the end
    while i + 1 < n
      return false unless nums[i] < nums[i + 1]

      i += 1
    end

    true
  end

  # @param {Integer[]} weight
  # @return {Integer}
  def max_balanced_shipments(weight)
    n = weight.length
    return 0 if n < 2

    shipments = 0
    start_idx = 0

    # We will iterate using a manual index so we can jump forward when we form a shipment
    i = 1
    max_so_far = weight[start_idx]

    while i < n
      if max_so_far > weight[i]
        # Balanced shipment found: weight[start_idx..i]
        shipments += 1
        start_idx = i + 1

        # If there are no more parcels left, we break early
        break if start_idx >= n - 1

        # Reset tracking for the next potential shipment
        max_so_far = weight[start_idx]
        i = start_idx + 1
      else
        max_so_far = weight[i] unless max_so_far > weight[i]
        i += 1
      end
    end

    shipments
  end

  # @param {String} s
  # @param {Integer[]} order
  # @param {Integer} k
  # @return {Integer}
  def min_time(s, order, k)
    n = s.length

    total_sub = n * (n + 1) / 2
    return -1 if total_sub < k # impossible even when every char is '*'

    # time_of_star[i] = time step when index i becomes '*'
    time_of_star = Array.new(n)
    order.each_with_index { |idx, t| time_of_star[idx] = t }

    # Helper -> does the string become active by time t?
    possible = lambda do |t|
      invalid = 0
      run_len = 0
      (0...n).each do |i|
        if time_of_star[i] <= t
          # star at this position – finish current run of non-stars
          if run_len.positive?
            invalid += run_len * (run_len + 1) / 2
            run_len = 0
          end
        else
          run_len += 1
        end
      end
      invalid += run_len * (run_len + 1) / 2 if run_len.positive?

      valid = total_sub - invalid
      valid >= k
    end

    return -1 unless possible.call(n - 1)

    lo = 0
    hi = n - 1
    ans = n - 1

    while lo <= hi
      mid = (lo + hi) / 2
      if possible.call(mid)
        ans = mid
        hi = mid - 1
      else
        lo = mid + 1
      end
    end

    ans
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def max_sum_trionic(nums); end
end
