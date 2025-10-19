# rubocop:disable Metrics/BlockLength
class Contest472
  # @param {Integer[]} nums
  # @param {Integer} k
  # @return {Integer}
  def missing_multiple(nums, k); end

  # @param {Integer[]} nums
  # @return {Integer}
  def longest_balanced(nums)
    n = nums.length
    max_len = 0

    n.times do |start_idx|
      even_seen = {}
      odd_seen = {}
      even_cnt = 0
      odd_cnt = 0

      start_idx.upto(n - 1) do |end_idx|
        val = nums[end_idx]
        if val.even?
          unless even_seen.key?(val)
            even_seen[val] = true
            even_cnt += 1
          end
        else
          unless odd_seen.key?(val)
            odd_seen[val] = true
            odd_cnt += 1
          end
        end

        if even_cnt == odd_cnt
          curr_len = end_idx - start_idx + 1
          max_len = curr_len if curr_len > max_len
        end
      end
    end

    max_len
  end

  # @param {String} s
  # @param {String} target
  # @return {String}
  def lex_greater_permutation(s, target)
    n = s.length
    counts = Array.new(26, 0)
    s.each_char { |ch| counts[ch.ord - 97] += 1 }

    # iterate pivot position from right to left
    (n - 1).downto(0) do |i|
      # remaining counts copy
      counts_left = counts.dup
      feasible = true

      # consume prefix equal to target[0...i]
      (0...i).each do |j|
        idx = target[j].ord - 97
        if counts_left[idx].zero?
          feasible = false
          break
        end
        counts_left[idx] -= 1
      end
      next unless feasible

      curr_idx = target[i].ord - 97
      # find next greater character to place at i
      ((curr_idx + 1)..25).each do |d|
        next if counts_left[d].zero?

        # build answer
        prefix = target[0...i]
        pivot_char = (97 + d).chr
        counts_after = counts_left.dup
        counts_after[d] -= 1
        suffix = ""
        0.upto(25) do |k|
          suffix << ((97 + k).chr * counts_after[k])
        end
        return prefix + pivot_char + suffix
      end
      # if no larger char, continue loop to earlier pivot
    end

    ""
  end

  # @param {Integer[]} nums
  # @return {Integer}
  def longest_balanced2(nums)
  end
end

# rubocop:enable Metrics/BlockLength
