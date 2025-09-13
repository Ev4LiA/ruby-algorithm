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

  # 3027. Find the Number of Ways to Place People II
  # @param {Integer[][]} points
  # @return {Integer}
  def number_of_pairs_ii(points)
    ans = 0
    points.sort! { |a, b| a[0] == b[0] ? b[1] - a[1] : a[0] - b[0] }

    (0...points.length - 1).each do |i|
      point_a = points[i]
      x_min = point_a[0] - 1
      x_max = Float::INFINITY
      y_min = -Float::INFINITY
      y_max = point_a[1] + 1

      (i + 1...points.length).each do |j|
        point_b = points[j]
        next unless point_b[0] > x_min &&
                    point_b[0] < x_max &&
                    point_b[1] > y_min &&
                    point_b[1] < y_max

        ans += 1
        x_min = point_b[0]
        y_min = point_b[1]
      end
    end

    ans
  end

  # 3516. Find Closest Person
  # @param {Integer} x
  # @param {Integer} y
  # @param {Integer} z
  # @return {Integer}
  def find_closest(x, y, z)
    dis1 = (z - x).abs
    dis2 = (z - y).abs
    return 2 if dis1 > dis2
    return 1 if dis1 < dis2

    0
  end

  # 2749. Minimum Operations to Make the Integer Zero
  # @param {Integer} num1
  # @param {Integer} num2
  # @return {Integer}
  def make_the_integer_zero(num1, num2)
    k = 1
    loop do
      x = num1 - (num2 * k)
      return -1 if x < k

      # Ruby's count_ones is equivalent to Java's Long.bitCount
      # to_s(2) converts to binary string, count('1') counts the 1s
      return k if k >= x.to_s(2).count("1")

      k += 1
    end
  end

  # 3495. Minimum Operations to Make Array Elements Zero
  # @param {Integer[][]} queries
  # @return {Integer}
  def min_operations(queries)
    get_opt = lambda do |num|
      count = 0
      i = 1
      base = 1
      while base <= num
        end_number = [(base * 2) - 1, num].min
        count += ((i + 1) / 2) * (end_number - base + 1)
        base *= 2
        i += 1
      end
      count
    end

    res = 0
    queries.each do |query|
      count1 = get_opt.call(query[1])
      count2 = get_opt.call(query[0] - 1)
      res += (count1 - count2 + 1) / 2
    end
    res
  end

  # 1304. Find N Unique Integers Sum up to Zero
  # @param {Integer} n
  # @return {Integer[]}
  def sum_zero(n)
    ans = Array.new(n, 0)
    index = 0

    (1..n / 2).each do |i|
      ans[index] = i
      ans[index + 1] = -i
      index += 2
    end
    ans[index] = 0 if n.odd?
    ans
  end

  # 1317. Convert Integer to the Sum of Two No-Zero Integers
  # @param {Integer} n
  # @return {Integer[]}
  def get_no_zero_integers(n)
    a = 1
    b = n - 1
    while b.to_s.include?("0") || a.to_s.include?("0")
      a += 1
      b -= 1
    end
    [a, b]
  end

  # 2327. Number of People Aware of a Secret
  # @param {Integer} n
  # @param {Integer} delay
  # @param {Integer} forget
  # @return {Integer}
  def people_aware_of_secret(n, delay, forget)
    mod = 1_000_000_007

    know   = [[1, 1]] # [day, count] currently aware of the secret
    share  = []       # [day, count] allowed to share
    know_cnt  = 1
    share_cnt = 0

    (2..n).each do |day|
      # people who reach the sharing threshold today
      if know.any? && know[0][0] == day - delay
        d, c = know.shift
        know_cnt  = (know_cnt - c) % mod
        share_cnt = (share_cnt + c) % mod
        share << [d, c]
      end

      # people who forget the secret today
      if share.any? && share[0][0] == day - forget
        _d, c = share.shift
        share_cnt = (share_cnt - c) % mod
      end

      # new people learn the secret today
      unless share.empty?
        know_cnt = (know_cnt + share_cnt) % mod
        know << [day, share_cnt]
      end
    end

    (know_cnt + share_cnt) % mod
  end

  # 1733. Minimum Number of People to Teach
  # @param {Integer} n
  # @param {Integer[][]} languages
  # @param {Integer[][]} friendships
  # @return {Integer}
  def minimum_teachings(n, languages, friendships)
    cannot_talk = Set.new

    friendships.each do |u, v|
      # users are 1-based in input, convert to 0-based indices
      u_langs = languages[u - 1]
      v_langs = languages[v - 1]

      # if they share no common language
      unless (u_langs & v_langs).any?
        cannot_talk << (u - 1)
        cannot_talk << (v - 1)
      end
    end

    counts   = Array.new(n + 1, 0) # counts[lang_id] = appearances among cannot_talk users
    max_cnt  = 0

    cannot_talk.each do |idx|
      languages[idx].each do |lang|
        counts[lang] += 1
        max_cnt = counts[lang] if counts[lang] > max_cnt
      end
    end

    cannot_talk.size - max_cnt
  end

  # 2785. Sort Vowels in a String
  # @param {String} s
  # @return {String}
  def sort_vowels(s)
    vowels = s.chars.select { |c| c.match?(/[aeiouAEIOU]/) }
    vowels.sort!
    s.chars.map { |c| c.match?(/[aeiouAEIOU]/) ? vowels.shift : c }.join
  end

  # 3227. Vowels Game in a String
  # @param {String} s
  # @return {Boolean}
  def does_alice_win(s)
    !!(s =~ /[aeiou]/)
  end

  # 3541. Find Most Frequent Vowel and Consonant
  # @param {String} s
  # @return {Integer}
  def max_freq_sum(s)
    vowel = 0
    consonant = 0

    hash = s.chars.tally

    hash.each do |char, count|
      if char.match?(/[aeiou]/)
        vowel = [vowel, count].max
      else
        consonant = [consonant, count].max
      end
    end

    vowel + consonant
  end
end
