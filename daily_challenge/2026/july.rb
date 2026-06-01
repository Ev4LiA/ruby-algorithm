class July2026
  # 2144. Minimum Cost of Buying Candies With Discount
  # @param {Integer[]} cost
  # @return {Integer}
  def minimum_cost(cost)
    cost.sort!.reverse!
    sum = 0
    count = 0
    cost.each do |num|
      if count < 2
        sum += num
        count += 1
      else
        count = 0
      end
    end

    sum
  end
end
