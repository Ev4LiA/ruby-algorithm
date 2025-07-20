require "rake"
require "rubocop/rake_task"

# Run RuboCop in parallel mode for faster feedback.
RuboCop::RakeTask.new(:lint) do |task|
  task.options = %w[--parallel]
end

# Auto-correct (format) all files. Use with caution in CI – it mutates code.
RuboCop::RakeTask.new(:autocorrect) do |task|
  task.options = %w[--parallel -A]
end

# Default rake task – lint only.
task default: :lint
