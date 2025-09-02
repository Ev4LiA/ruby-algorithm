# frozen_string_literal: true

class September2025
  # 1792. Maximum Average Pass Ratio
  # @param {Integer[][]} classes
  # @param {Integer} extra_students
  # @return {Float}
  def max_average_ratio(classes, extra_students)
    # Helper to compute the marginal gain when one extra student is added.
    delta = lambda do |pass, total|
      ((pass + 1).to_f / (total + 1)) - (pass.to_f / total)
    end

    # Simple binary heap (max-heap) implementation specialised for our tuples.
    heap = [] # elements: [gain, pass, total]

    sift_up = lambda do |idx|
      while idx.positive?
        parent = (idx - 1) / 2
        break if heap[parent][0] >= heap[idx][0]

        heap[parent], heap[idx] = heap[idx], heap[parent]
        idx = parent
      end
    end

    sift_down = lambda do |idx|
      size = heap.size
      loop do
        left = (idx * 2) + 1
        right = (idx * 2) + 2
        largest = idx

        largest = left if left < size && heap[left][0] > heap[largest][0]
        largest = right if right < size && heap[right][0] > heap[largest][0]

        break if largest == idx

        heap[largest], heap[idx] = heap[idx], heap[largest]
        idx = largest
      end
    end

    # Build initial heap
    classes.each do |pass, total|
      heap << [delta.call(pass, total), pass, total]
    end
    (heap.size / 2).downto(0) { |i| sift_down.call(i) }

    # Assign extra students
    extra_students.times do
      gain, pass, total = heap[0]
      pass += 1
      total += 1
      heap[0] = [delta.call(pass, total), pass, total]
      sift_down.call(0)
    end

    # Compute final average
    sum = heap.reduce(0.0) { |acc, (_, p, t)| acc + (p.to_f / t) }
    sum / heap.size
  end

  # 3025. Find the Number of Ways to Place People I
  # @param {Integer[][]} points
  # @return {Integer}
  def number_of_pairs(points)
    ans = 0
    n = points.length
    (0...n).each do |i|
      point_a = points[i]
      (0...n).each do |j|
        point_b = points[j]

        next if i == j || !(point_a[0] <= point_b[0] && point_a[1] >= point_b[1])

        if n == 2
          ans += 1
          next
        end

        illegal = false
        (0...n).each do |k|
          next if i == k || j == k

          point_tmp = points[k]
          is_x_contained = point_tmp[0] >= point_a[0] && point_tmp[0] <= point_b[0]
          is_y_contained = point_tmp[1] <= point_a[1] && point_tmp[1] >= point_b[1]
          if is_x_contained && is_y_contained
            illegal = true
            break
          end
        end

        ans += 1 unless illegal
      end
    end
    ans
  end
end
