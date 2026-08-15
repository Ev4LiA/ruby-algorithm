class Context189
  # Elevator Requests I
  # @param {Integer} n
  # @param {Integer[]} requests
  # @return {Integer}
  def elevator_requests(n, requests)
    time = 0
    current = 0
    requests.each do |floor|
      time += (floor - current).abs
      current = floor
    end
    time
  end

  # Minimum Operations to Make a Rotated Palindrome I
  # @param {String} s
  # @return {Integer}
  def min_operations(s)
    n = s.length
    codes = s.bytes.map { |b| b - 97 }
    best = Float::INFINITY

    n.times do |r|
      total = r
      (0...n / 2).each do |i|
        a = codes[(r + i) % n]
        b = codes[(r + n - 1 - i) % n]
        d = (a - b).abs
        total += [d, 26 - d].min
      end
      best = total if total < best
    end

    best
  end

  # K-th Digit in Infinite String
  # @param {Integer} k
  # @return {Integer}
  def kth_digit(k)
    # Block 0 is special: numbers 1..9, nine 1-digit chars.
    if k <= 9
      return k   # "123456789", kth digit is k itself
    end

    k -= 9       # consumed block 0

    # Now handle blocks b >= 1, grouped by digit width d.
    # Blocks with d-digit numbers: b in [10^(d-2), 10^(d-1) - 1], for d >= 2.
    # Each such block has length 10*d. Count of blocks in the group:
    #   d == 2: b in [1, 9]      -> 9 blocks
    #   d >= 3: b in [10^(d-2), 10^(d-1)-1] -> 9 * 10^(d-2) blocks
    d = 2
    loop do
      num_blocks = d == 2 ? 9 : 9 * (10**(d - 2))
      group_len  = num_blocks * (10 * d)
      if k > group_len
        k -= group_len
        d += 1
        next
      end

      # k falls within this width group. Find which block.
      block_len   = 10 * d # digits per block in this group
      first_block = d == 2 ? 1 : 10**(d - 2)
      idx_in_grp  = (k - 1) / block_len   # 0-based block offset within group
      b           = first_block + idx_in_grp
      pos_in_blk  = (k - 1) % block_len   # 0-based digit index within the block

      # Which of the 10 numbers, and which digit inside it.
      num_idx  = pos_in_blk / d # 0-based index among the 10 numbers
      digit_ix = pos_in_blk % d

      # Ordering within the block: even b increasing, odd b decreasing.
      number = b.even? ? ((10 * b) + num_idx) : ((10 * b) + 9 - num_idx)

      return number.to_s[digit_ix].to_i
    end
  end
end
