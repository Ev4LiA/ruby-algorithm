class MovieRentingSystem
  attr_accessor :n, :inventory, :movies_by_id, :rented, :rented_movies

  # @param n [Integer] number of shops
  # @param entries [Array<Array<Integer>>] array of [shop, movie, price] entries
  def initialize(n, entries)
    @n = n
    # Hash to store movie inventory: {shop => {movie => price}}
    @inventory = {}
    # Hash to store movies by movie_id: {movie_id => [[shop, price], ...]}
    @movies_by_id = {}
    # Set to track rented movies: Set of [shop, movie] pairs
    @rented = Set.new
    # Array to store rented movies with their prices for efficient reporting
    @rented_movies = []

    # Initialize inventory and movies_by_id
    entries.each do |shop, movie, price|
      @inventory[shop] ||= {}
      @inventory[shop][movie] = price

      @movies_by_id[movie] ||= []
      @movies_by_id[movie] << [shop, price]
    end

    # Sort movies_by_id by price, then by shop for efficient searching
    @movies_by_id.each do |_movie_id, shops|
      shops.sort_by! { |shop, price| [price, shop] }
    end
  end

  # @param movie [Integer] movie ID to search for
  # @return [Array<Integer>] array of shop IDs with unrented copies
  def search(movie)
    return [] unless @movies_by_id[movie]

    result = []
    @movies_by_id[movie].each do |shop, _price|
      # Check if this movie is not rented
      unless @rented.include?([shop, movie])
        result << shop
        break if result.size == 5
      end
    end

    result
  end

  # @param shop [Integer] shop ID
  # @param movie [Integer] movie ID to rent
  def rent(shop, movie)
    # Mark movie as rented
    @rented.add([shop, movie])

    # Add to rented_movies array for efficient reporting
    price = @inventory[shop][movie]
    @rented_movies << [price, shop, movie]
    @rented_movies.sort_by! { |p, s, m| [p, s, m] }
  end

  # @param shop [Integer] shop ID
  # @param movie [Integer] movie ID to drop off
  def drop(shop, movie)
    # Remove from rented set
    @rented.delete([shop, movie])

    # Remove from rented_movies array
    price = @inventory[shop][movie]
    @rented_movies.delete([price, shop, movie])
  end

  # @return [Array<Array<Integer>>] array of [shop, movie] pairs for cheapest rented movies
  def report
    # Return first 5 rented movies (already sorted by price, shop, movie)
    @rented_movies.first(5).map { |_price, shop, movie| [shop, movie] }
  end
end

# Your MovieRentingSystem object will be instantiated and called as such:
# obj = MovieRentingSystem.new(n, entries)
# param_1 = obj.search(movie)
# obj.rent(shop, movie)
# obj.drop(shop, movie)
# param_4 = obj.report()
