class Contest510
  # Number of Elapsed Seconds Between Two Times©leetcode
  # @param {String} start_time
  # @param {String} end_time
  # @return {Integer}
  def seconds_between_times(start_time, end_time)
    sh, sm, ss = start_time.split(":").map!(&:to_i)
    eh, em, es = end_time.split(":").map!(&:to_i)

    start_seconds = (sh * 3600) + (sm * 60) + ss
    end_seconds   = (eh * 3600) + (em * 60) + es

    end_seconds - start_seconds
  end

  # Minimum Total Cost to Process All Elements©leetcode
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def minimum_cost(nums, k)
    mod = 1_000_000_007

    # current available resources
    cur = k

    # how many "add k" operations have been used so far
    ops_used = 0

    # total cost (sum of 1..ops_used at each step we extend)
    total_cost = 0

    nums.each do |need|
      if cur < need
        deficit = need - cur
        # how many more operations we at least need
        extra_ops = (deficit + k - 1) / k # ceil(deficit / k)

        # new total ops after adding these
        new_ops_used = ops_used + extra_ops

        # cost of these extra_ops is (sum 1..new_ops_used) - (sum 1..ops_used)
        # sum 1..n = n * (n + 1) / 2
        add_cost = (new_ops_used * (new_ops_used + 1) / 2) -
                   (ops_used * (ops_used + 1) / 2)

        total_cost = (total_cost + add_cost) % mod

        # update ops_used
        ops_used = new_ops_used

        # increase resources
        cur += extra_ops * k
      end

      # process current element
      cur -= need
    end

    total_cost % mod
  end
end
