class April2026
  # 874. Walking Robot Simulation
  # @param {Integer[]} commands
  # @param {Integer[][]} obstacles
  # @return {Integer}
  def robot_sim(commands, obstacles)
    lb = 30_000
    ob_set = Set.new

    obstacles.each do |ob|
      x = ob[0] + lb
      y = ob[1] + lb
      ob_set.add((x << 16) + y)
    end

    dir = [[0, 1], [-1, 0], [0, -1], [1, 0]]
    x = 0
    y = 0
    face = 0
    dx = dir[face][0]
    dy = dir[face][1]
    max_d2 = 0

    commands.each do |c|
      case c
      when -2
        face = (face + 1) & 3
        dx = dir[face][0]
        dy = dir[face][1]
      when -1
        face = (face + 3) & 3
        dx = dir[face][0]
        dy = dir[face][1]
      else
        c.times do
          x += dx
          y += dy
          if ob_set.include?(((x + lb) << 16) + y + lb)
            x -= dx
            y -= dy
            break
          end
          d2 = (x * x) + (y * y)
          max_d2 = d2 if d2 > max_d2
        end
      end
    end

    max_d2
  end
end
