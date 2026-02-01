require 'set'

class RideSharingSystem
  def initialize
    @driver_queue = []
    @rider_queue = []
    @waiting_riders = Set.new
    @cancelled_riders = Set.new
  end

  # @param {Integer} rider_id
  # @return {Void}
  def add_rider(rider_id)
    @rider_queue << rider_id
    @waiting_riders << rider_id
  end

  # @param {Integer} driver_id
  # @return {Void}
  def add_driver(driver_id)
    @driver_queue << driver_id
  end

  # @return {Integer[]}
  def match_driver_with_rider
    driver = @driver_queue.shift
    return [-1, -1] if driver.nil?

    rider = nil
    until @rider_queue.empty?
      r = @rider_queue.shift
      unless @cancelled_riders.include?(r)
        rider = r
        break
      end
    end

    if rider.nil?
      @driver_queue.unshift(driver)
      return [-1, -1]
    end

    @waiting_riders.delete(rider)
    [driver, rider]
  end

  # @param {Integer} rider_id
  # @return {Void}
  def cancel_rider(rider_id)
    return unless @waiting_riders.include?(rider_id)

    @cancelled_riders << rider_id
    @waiting_riders.delete(rider_id)
  end
end
