class Router
  attr_accessor :max_capacity, :duplicate_tracker, :packet_queue, :destination_timestamps, :forwarded_counts

  # @param memory_limit [Integer] memory limit
  def initialize(memory_limit)
    @max_capacity = memory_limit

    @duplicate_tracker = Set.new
    @packet_queue = []

    @destination_timestamps = {}
    @forwarded_counts = {}
  end

  # @param source [Integer] source
  # @param destination [Integer] destination
  # @param timestamp [Integer] timestamp
  # @return [Boolean]
  def add_packet(source, destination, timestamp)
    return false if duplicate_tracker.include?([source, destination, timestamp])

    remove_oldest_packet if packet_queue.size >= max_capacity

    packet_queue << [source, destination, timestamp]
    duplicate_tracker << [source, destination, timestamp]

    destination_timestamps[destination] ||= []
    destination_timestamps[destination] << timestamp

    true
  end

  # @return [Integer[]]
  def forward_packet
    return [] if packet_queue.empty?

    packet = packet_queue.shift
    duplicate_tracker.delete(packet)

    destination = packet[1]
    forwarded_counts[destination] ||= 0
    forwarded_counts[destination] += 1

    packet
  end

  # @param destination [Integer] destination
  # @param start_time [Integer] start time
  # @param end_time [Integer] end time
  # @return [Integer]
  def get_count(destination, start_time, end_time)
    return 0 unless @destination_timestamps.key?(destination)

    timestamp_list = destination_timestamps[destination]
    forwarded_count = forwarded_counts[destination] || 0

    left = find_lower_bound(timestamp_list, start_time, forwarded_count)
    right = find_upper_bound(timestamp_list, end_time, forwarded_count)

    right - left
  end

  private

  def remove_oldest_packet
    oldest_packet = packet_queue.shift
    duplicate_tracker.delete(oldest_packet)

    destination = oldest_packet[1]
    forwarded_counts[destination] ||= 0
    forwarded_counts[destination] += 1
  end

  # Binary search to find the first index where timestamp >= target
  # @param timestamps [Array] array of timestamps (sorted)
  # @param target [Integer] target timestamp
  # @param start_index [Integer] starting index to search from
  # @return [Integer] index of first element >= target
  def find_lower_bound(timestamps, target, start_index)
    left = start_index
    right = timestamps.size

    while left < right
      mid = left + ((right - left) / 2)
      if timestamps[mid] < target
        left = mid + 1
      else
        right = mid
      end
    end

    left
  end

  # Binary search to find the first index where timestamp > target
  # @param timestamps [Array] array of timestamps (sorted)
  # @param target [Integer] target timestamp
  # @param start_index [Integer] starting index to search from
  # @return [Integer] index of first element > target
  def find_upper_bound(timestamps, target, start_index)
    left = start_index
    right = timestamps.size

    while left < right
      mid = left + ((right - left) / 2)
      if timestamps[mid] <= target
        left = mid + 1
      else
        right = mid
      end
    end

    left
  end
end

# Your Router object will be instantiated and called as such:
# obj = Router.new(memory_limit)
# param_1 = obj.add_packet(source, destination, timestamp)
# param_2 = obj.forward_packet()
# param_3 = obj.get_count(destination, start_time, end_time)
