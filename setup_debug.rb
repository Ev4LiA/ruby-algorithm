# Setup file to auto-load debug gem
# Add this line at the top of files where you want to debug:
# require_relative '../setup_debug'

require "bundler/setup"
require "debug"

# Make debugger method available globally
module Kernel
  def debugger
    binding.break
  end
end
