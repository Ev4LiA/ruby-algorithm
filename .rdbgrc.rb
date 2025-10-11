# This file is automatically loaded by rdbg when debugging starts
# It ensures the debug gem is always available

# The debug gem is already loaded by rdbg, so we just need to
# make sure it's available in the global scope
Object.class_eval do
  def debugger
    binding.break
  end
end
