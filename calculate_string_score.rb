def calculate_string_score(s)
  vowels = ['a', 'e', 'i', 'o', 'u']
  v = 0 # number of vowels
  c = 0 # number of consonants

  s.each_char do |char|
    if char >= 'a' && char <= 'z'
      if vowels.include?(char)
        v += 1
      else
        c += 1
      end
    end
  end

  if c > 0
    (v / c).floor
  else
    0
  end
end
