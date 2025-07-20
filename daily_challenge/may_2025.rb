class May2025
  # @param {String[]} words
  # @return {Integer}
  def longest_palindrome(words)
    # Count frequency of each word
    count = Hash.new(0)
    words.each { |word| count[word] += 1 }

    pairs = 0
    middle = false

    count.each do |word, freq|
      if word[0] == word[1]  # Self-palindromic word like "aa", "bb"ea
        pairs += freq / 2    # Number of pairs we can form
        middle = true if freq.odd? # If there's one left over, it can be the middle
      else
        # For reverse pairs like "ab" and "ba"
        reverse_word = word.reverse
        if count[reverse_word] > 0 && word < reverse_word # Avoid double counting
          pairs += [freq, count[reverse_word]].min
        end
      end
    end

    result = pairs * 4      # Each pair contributes 4 characters
    result += 2 if middle   # Middle word contributes 2 characters
    result
  end

  # @param {Integer[][]} board
  # @return {Integer}
  def snakes_and_ladders(board)
    n = board.size
    min_rolls = Array.new((n * n) + 1, -1)
    queue = Queue.new
    min_rolls[1] = 0
    queue.push(1)

    until queue.empty?
      x = queue.pop
      (1..6).each do |i|
        break if x + i > n * n

        t = x + i
        row = (t - 1) / n
        col = (t - 1) % n
        v = board[n - 1 - row][row.odd? ? n - 1 - col : col]
        y = v > 0 ? v : t # follow ladder / snake if present

        return min_rolls[x] + 1 if y == n * n

        if min_rolls[y] == -1
          min_rolls[y] = min_rolls[x] + 1
          queue.push(y)
        end
      end
    end

    -1
  end
end
