class Contest192
  # @param {Integer[]} source
  # @param {Integer[]} target
  # @return {Integer}
  def min_queen_moves(source, target)
    sr, sc = source
    tr, tc = target

    return 0 if sr == tr && sc == tc

    # Same row, same column, or same diagonal → reachable in one move
    return 1 if sr == tr || sc == tc || (sr - tr).abs == (sc - tc).abs

    # Otherwise the queen always needs exactly two moves
    2
  end

  # @param {Integer[]} source
  # @param {Integer[]} target
  # @return {Boolean}
  def can_transform(source, target)
    source.sum == target.sum
  end
end
