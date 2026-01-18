class Contest485
  # @param {String} s
  # @return {Integer}
  def vowel_consonant_score(s)
    vowels = %w[a e i o u]
    v = 0
    c = 0

    s.each_char do |char|
      if char >= "a" && char <= "z"
        if vowels.include?(char)
          v += 1
        else
          c += 1
        end
      end
    end

    if c > 0
      (v / c).floor
    else
      0
    end
  end

  # @param {Integer[]} costs
  # @param {Integer[]} capacity
  # @param {Integer} budget
  # @return {Integer}
  def max_capacity(costs, capacity, budget)
    n = costs.length
    sorted_machines = costs.zip(capacity).sort_by { |cost, _cap| cost }

    max_cap = 0

    # Case 1: Select one machine
    sorted_machines.each do |cost, cap|
      max_cap = [max_cap, cap].max if cost < budget
    end

    # Case 2: Select two machines
    return max_cap if n < 2

    max_cap_prefix = Array.new(n)
    max_cap_prefix[0] = sorted_machines[0][1]
    (1...n).each do |i|
      max_cap_prefix[i] = [max_cap_prefix[i - 1], sorted_machines[i][1]].max
    end

    (1...n).each do |i|
      cost_i, cap_i = sorted_machines[i]
      remaining_budget = budget - cost_i

      next if remaining_budget <= 0

      # Binary search for the rightmost j < i such that sorted_machines[j][0] < remaining_budget
      l = 0
      r = i - 1
      best_j = -1
      while l <= r
        mid = l + ((r - l) / 2)
        if sorted_machines[mid][0] < remaining_budget
          best_j = mid
          l = mid + 1
        else
          r = mid - 1
        end
      end

      max_cap = [max_cap, cap_i + max_cap_prefix[best_j]].max if best_j != -1
    end

    max_cap
  end
end
