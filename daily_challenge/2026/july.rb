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

  # 3633. Earliest Finish Time for Land and Water Rides I
  # @param {Integer[]} land_start_time
  # @param {Integer[]} land_duration
  # @param {Integer[]} water_start_time
  # @param {Integer[]} water_duration
  # @return {Integer}
  def earliest_finish_time(land_start_time, land_duration, water_start_time, water_duration)
    n = land_start_time.length
    m = water_start_time.length

    res = Float::INFINITY

    (0...n).each do |i|
      (0...m).each do |j|
        # land first, then water
        land_finish = land_start_time[i] + land_duration[i]
        land_then_water = [land_finish, water_start_time[j]].max + water_duration[j]
        res = [res, land_then_water].min

        # water first, then land
        water_finish = water_start_time[j] + water_duration[j]
        water_then_land = [water_finish, land_start_time[i]].max + land_duration[i]
        res = [res, water_then_land].min
      end
    end

    res
  end
end
