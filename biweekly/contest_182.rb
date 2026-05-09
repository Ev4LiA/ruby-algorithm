class Contest182
  # @param {String[]} events
  # @return {Integer[]}
  def score_validator(events)
    score = 0
    counter = 0

    events.each do |event|
      break if counter == 10

      case event
      when "0", "1", "2", "3", "4", "6"
        score += event.to_i
      when "W"
        counter += 1
      when "WD", "NB"
        score += 1
      end
    end

    [score, counter]
  end

  # @param {String} s
  # @return {Integer}
  def min_flips(s)
    states = 16
    trans = Array.new(states) { Array.new(2, -1) }

    16.times do |mask|
      a = (mask & 1) != 0
      b = (mask & 2) != 0
      c = (mask & 4) != 0
      d = (mask & 8) != 0

      # input 0
      unless d
        a0 = true
        b0 = b
        c0 = c
        d0 = d
        mask0 = (a0 ? 1 : 0) |
                (b0 ? 2 : 0) |
                (c0 ? 4 : 0) |
                (d0 ? 8 : 0)
        trans[mask][0] = mask0
      end

      # input 1
      next if b

      a1 = a
      b1 = b || a
      c1 = true
      d1 = d || c
      mask1 = (a1 ? 1 : 0) |
              (b1 ? 2 : 0) |
              (c1 ? 4 : 0) |
              (d1 ? 8 : 0)
      trans[mask][1] = mask1
    end

    inf = 10**9
    dp = Array.new(states, inf)
    dp[0] = 0

    s.each_char do |ch|
      ndp = Array.new(states, inf)
      cur_bit = (ch == "1" ? 1 : 0)

      states.times do |st|
        next if dp[st] == inf

        2.times do |bit|
          nxt = trans[st][bit]
          next if nxt == -1

          cost = dp[st] + (bit == cur_bit ? 0 : 1)
          ndp[nxt] = cost if cost < ndp[nxt]
        end
      end

      dp = ndp
    end

    dp.min
  end
end
