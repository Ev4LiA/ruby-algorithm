class Contest491
  # @param {String} s
  # @return {String}
  def trim_trailing_vowels(s)
    vowels = %w[a e i o u]
    i = s.length - 1
    i -= 1 while i >= 0 && vowels.include?(s[i])

    return "" if i < 0

    s[0..i]
  end

  # @param {Integer} n
  # @return {Integer}
  def min_cost(n)
    n * (n - 1) / 2
  end

  # @param {Integer[][]} grid
  # @return {Integer}
  def minimum_or(grid)
    res = 0
    17.downto(0) do |b|
      bit = 1 << b
      # We want to check if it's possible to achieve a result
      # that doesn't have the b-th bit set, given the bits
      # we've already committed to in `res`.
      # The test_mask represents all numbers with the same prefix as `res`
      # but with the b-th bit as 0.
      test_mask = res | (bit - 1)

      possible_to_keep_zero = true
      grid.each do |row|
        found_submask_in_row = false
        row.each do |x|
          # Check if x is a submask of test_mask
          if (x | test_mask) == test_mask
            found_submask_in_row = true
            break
          end
        end

        unless found_submask_in_row
          possible_to_keep_zero = false
          break
        end
      end

      # If it's not possible to keep the b-th bit as 0 for all rows,
      # we are forced to have a 1 at this bit position.
      res |= bit unless possible_to_keep_zero
    end
    res
  end
end
