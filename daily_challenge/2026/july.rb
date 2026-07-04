class July2026
  # 2492. Minimum Score of a Path Between Two Cities
  # @param {Integer} n
  # @param {Integer[][]} roads
  # @return {Integer}
  def min_score(n, roads)
    # Build adjacency list: undirected graph
    graph = Array.new(n + 1) { [] }
    roads.each do |u, v, w|
      graph[u] << [v, w]
      graph[v] << [u, w]
    end

    # BFS/DFS from node 1 to traverse its entire connected component.
    # The answer is the minimum edge weight seen on any edge reachable from 1.
    visited = Array.new(n + 1, false)
    queue = [1]
    visited[1] = true
    min_edge = Float::INFINITY

    until queue.empty?
      node = queue.shift

      graph[node].each do |neighbor, weight|
        min_edge = [min_edge, weight].min

        unless visited[neighbor]
          visited[neighbor] = true
          queue << neighbor
        end
      end
    end

    min_edge
  end
end
