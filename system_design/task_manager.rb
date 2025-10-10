class TaskManager
  # @param tasks [Integer[][]] tasks
  def initialize(tasks); end

  # @param user_id [Integer] user id
  # @param task_id [Integer] task id
  # @param priority [Integer] priority
  def add(user_id, task_id, priority); end

  # @param task_id [Integer] task id
  # @param new_priority [Integer] new priority
  def edit(task_id, new_priority); end

  # @param task_id [Integer] task id
  def rmv(task_id); end

  # @return [Integer]
  def exec_top; end
end

# Your TaskManager object will be instantiated and called as such:
# obj = TaskManager.new(tasks)
# obj.add(user_id, task_id, priority)
# obj.edit(task_id, new_priority)
# obj.rmv(task_id)
# param_4 = obj.exec_top()
