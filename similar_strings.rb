# @param {String[]} words
# @return {Integer}
def count_similar_pairs(words)
  frequencies = Hash.new(0)

  words.each do |word|
    first_char_code = word[0].ord
    shift = ('a'.ord - first_char_code + 26) % 26

    normalized_word_chars = word.chars.map do |char|
      ((char.ord - 'a'.ord + shift) % 26 + 'a'.ord).chr
    end
    normalized_word = normalized_word_chars.join
    frequencies[normalized_word] += 1
  end

  total_pairs = 0
  frequencies.each_value do |count|
    total_pairs += count * (count - 1) / 2
  end

  total_pairs
end
