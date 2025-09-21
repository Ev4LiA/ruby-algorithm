class FoodRatings
  # @param foods [String[]]
  # @param cuisines [String[]]
  # @param ratings [Integer[]]
  def initialize(foods, cuisines, ratings); end

  # @param food [String]
  # @param new_rating [Integer]
  def change_rating(food, new_rating); end

  # @param cuisine [String]
  # @return [String]
  def highest_rated(cuisine); end
end

# Your FoodRatings object will be instantiated and called as such:
# obj = FoodRatings.new(foods, cuisines, ratings)
# obj.change_rating(food, new_rating)
# param_2 = obj.highest_rated(cuisine)
