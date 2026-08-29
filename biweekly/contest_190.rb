class Contest_190
  # Minimum Bishop Moves to Reach Target
  # @param {Integer[]} source
  # @param {Integer[]} target
  # @return {Integer}
  def min_bishop_moves(source, target)
    sr, sc = source
    tr, tc = target

    # If they are on different colors, bishop can never reach
    return -1 if (sr + sc) % 2 != (tr + tc) % 2

    # If on the same diagonal, 1 move
    return 1 if (sr + sc) == (tr + tc) || (sr - sc) == (tr - tc)

    # Otherwise it will always take 2 moves
    2
  end 
end
