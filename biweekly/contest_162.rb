class Contest162
  # @param {Integer[]} land_start_time
  # @param {Integer[]} land_duration
  # @param {Integer[]} water_start_time
  # @param {Integer[]} water_duration
  # @return {Integer}
  def earliest_finish_time(land_start_time, land_duration, water_start_time, water_duration)
    min_finish = Float::INFINITY

    land_start_time.each_with_index do |ls, i|
      water_start_time.each_with_index do |ws, j|
        land_finish   = ls + land_duration[i]
        water_begin   = [land_finish, ws].max
        total_finish1 = water_begin + water_duration[j]
        min_finish = total_finish1 if total_finish1 < min_finish

        water_finish  = ws + water_duration[j]
        land_begin    = [water_finish, ls].max
        total_finish2 = land_begin + land_duration[i]
        min_finish = total_finish2 if total_finish2 < min_finish
      end
    end

    min_finish
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def min_removal(nums, k)
    nums.sort!
    n = nums.length
    left = 0
    max_keep = 0

    nums.each_with_index do |val, right|
      left += 1 while left <= right && val > nums[left] * k
      window_len = right - left + 1
      max_keep = window_len if window_len > max_keep
    end

    n - max_keep
  end

  # @param {Integer[]} land_start_time
  # @param {Integer[]} land_duration
  # @param {Integer[]} water_start_time
  # @param {Integer[]} water_duration
  # @return {Integer}
  def earliest_finish_time_2(land_start_time, land_duration, water_start_time, water_duration)
    n = land_start_time.length
    m = water_start_time.length

    min_land_finish = Float::INFINITY
    min_land_duration = Float::INFINITY
    land_finish_with_start_ge = Float::INFINITY

    n.times do |i|
      ls = land_start_time[i]
      ld = land_duration[i]
      finish = ls + ld
      min_land_finish = finish if finish < min_land_finish
      min_land_duration = ld if ld < min_land_duration
    end

    min_water_open_plus_dur_ge = Float::INFINITY
    min_wdur = Float::INFINITY
    min_water_finish = Float::INFINITY

    m.times do |j|
      ws = water_start_time[j]
      wd = water_duration[j]
      open_plus_dur = ws + wd

      min_wdur = wd if wd < min_wdur
      min_water_finish = open_plus_dur if open_plus_dur < min_water_finish

      if ws >= min_land_finish && open_plus_dur < min_water_open_plus_dur_ge
        min_water_open_plus_dur_ge = open_plus_dur
      end
    end

    n.times do |i|
      ls = land_start_time[i]
      finish = ls + land_duration[i]
      if ls >= min_water_finish && finish < land_finish_with_start_ge
        land_finish_with_start_ge = finish
      end
    end

    option1_a = min_land_finish + min_wdur
    option1_b = min_water_open_plus_dur_ge
    option1 = [option1_a, option1_b].min

    option2_a = land_finish_with_start_ge
    option2_b = min_water_finish + min_land_duration
    option2 = [option2_a, option2_b].min

    [option1, option2].min
  end
end
