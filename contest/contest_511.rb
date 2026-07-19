class Contest511
  # Even Number of Knight Moves
  # @param {Integer[]} start
  # @param {Integer[]} target
  # @return {Boolean}
  def can_reach(start, target)
    moves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]

    visited = Array.new(8) { Array.new(8) { [false, false] } }

    queue = [[start[0], start[1], 0]]
    visited[start[0]][start[1]][0] = true

    until queue.empty?
      x, y, parity = queue.shift

      return true if x == target[0] && y == target[1] && parity == 0

      moves.each do |dx, dy|
        nx = x + dx
        ny = y + dy
        next_parity = 1 - parity

        next unless nx.between?(0, 7) && ny.between?(0, 7)
        next if visited[nx][ny][next_parity]

        visited[nx][ny][next_parity] = true
        queue << [nx, ny, next_parity]
      end
    end

    false
  end

  # Count Dominant Nodes in a Binary Tree
  # Definition for a binary tree node.
  # class TreeNode
  #   attr_accessor :val, :left, :right
  #   def initialize(val = 0, left = nil, right = nil)
  #     @val = val
  #     @left = left
  #     @right = right
  #   end
  # end

  # @param {TreeNode} root
  # @return {Integer}
  def count_dominant(root)
    count = 0

    # Returns the maximum value in the subtree rooted at node
    dfs = lambda do |node|
      return -Float::INFINITY if node.nil?

      left_max  = dfs.call(node.left)
      right_max = dfs.call(node.right)
      subtree_max = [node.val, left_max, right_max].max

      # Node is dominant if its value equals the max in its subtree
      count += 1 if node.val == subtree_max

      subtree_max
    end

    dfs.call(root)
    count
  end
end
