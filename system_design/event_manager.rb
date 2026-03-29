# frozen_string_literal: true

require 'set'

# Implements an event manager that handles events with priorities.
class EventManager
  # Initializes the manager with a list of events.
  #
  # @param events [Array<Array<Integer>>] An array of events, where each event is `[eventId, priority]`.
  def initialize(events)
    @event_priorities = {}
    @active_events = SortedSet.new

    events.each do |id, priority|
      @event_priorities[id] = priority
      # We store [-priority, id] in the SortedSet.
      # The negative priority makes the set sort by priority in descending order.
      # The id is used as a tie-breaker, sorting in ascending order.
      @active_events.add([-priority, id])
    end
  end

  # Updates the priority of an active event.
  #
  # @param event_id [Integer] The ID of the event to update.
  # @param new_priority [Integer] The new priority for the event.
  # @return [void]
  def update_priority(event_id, new_priority)
    old_priority = @event_priorities[event_id]

    return if old_priority == new_priority

    # Remove the old event entry from the set.
    @active_events.delete([-old_priority, event_id])
    # Add the new event entry to the set.
    @active_events.add([-new_priority, event_id])
    # Update the priority in the map.
    @event_priorities[event_id] = new_priority
  end

  # Removes and returns the event with the highest priority.
  #
  # If there's a tie in priority, the event with the smallest eventId is chosen.
  #
  # @return [Integer] The eventId of the highest priority event, or -1 if no active events exist.
  def poll_highest
    return -1 if @active_events.empty?

    highest_event = @active_events.first
    _neg_prio, event_id = highest_event

    @active_events.delete(highest_event)
    @event_priorities.delete(event_id)

    event_id
  end
end
