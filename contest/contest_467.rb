class Contest467
  # @param {Integer[][]} tasks
  # @return {Integer}
  def earliest_time(tasks)
    earliest_time = Float::INFINITY
    tasks.each do |task|
      earliest_time = [earliest_time, task[0] + task[1]].min
    end
    earliest_time
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer[]}
  def max_k_distinct(nums, k)
    nums.uniq.max(k)
  end

  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Boolean[]}
  def subsequence_sum_after_capping(nums, k)
    n = nums.length
    max_val = n
    # frequency of original values
    freq = Array.new(max_val + 1, 0)
    nums.each { |v| freq[v] += 1 }

    # Precompute prefix bitsets using Integer as bitset (bit i set => sum i achievable)
    limit_mask = (1 << (k + 1)) - 1
    prefix = Array.new(max_val + 1)
    dp = 1 # only sum 0 reachable initially
    prefix[0] = dp

    (1..max_val).each do |v|
      freq[v].times do
        dp |= (dp << v) & limit_mask
      end
      prefix[v] = dp
    end

    # compute counts of elements >= x
    cnt_ge = Array.new(max_val + 2, 0)
    max_val.downto(1) do |x|
      cnt_ge[x] = cnt_ge[x + 1] + freq[x]
    end

    answer = Array.new(max_val, false)

    (1..max_val).each do |x|
      dp_small = prefix[x - 1]
      big_cnt = cnt_ge[x]

      # iterate sums s up to k
      (0..k).each do |s|
        next if ((dp_small >> s) & 1).zero?

        # ensure non-empty subsequence if using only small part
        if s == k && s.positive?
          answer[x - 1] = true
          break
        end
        rem = k - s
        next if rem <= 0

        next unless rem % x == 0

        t = rem / x
        if t >= 1 && t <= big_cnt
          answer[x - 1] = true
          break
        end
      end
    end

    answer
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def count_stable_subsequences(nums); end

  MOD = 1_000_000_007

  # @param {Integer[]} nums
  # @return {Integer}
  def stable_subsequence_count(nums)
    # counts[parity*2 + (len-1)] stores number of subsequences with given ending parity and run length (1 or 2)
    counts = [0, 0, 0, 0]

    nums.each do |num|
      p = num & 1
      new_counts = counts.dup

      # start new subsequence with single element
      new_counts[p * 2] = (new_counts[p * 2] + 1) % MOD

      counts.each_with_index do |c, idx|
        next if c.zero?
        q = idx / 2
        len = (idx % 2) + 1

        next_state_idx = nil
        if p == q
          next if len == 2 # would make 3 consecutive same parity
          next_state_idx = (p * 2) + 1 # len becomes 2
        else
          next_state_idx = (p * 2) # len resets to 1
        end
        new_counts[next_state_idx] = (new_counts[next_state_idx] + c) % MOD
      end

      counts = new_counts
    end

    (counts.sum) % MOD
  end
end
