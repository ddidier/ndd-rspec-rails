require 'bundler/gem_tasks'
require 'rspec/core/rake_task'


# --- Start of workaround
# Rake 12 removes the 'last_comment' method which RSpec < 3.4.4 uses.
# But we need to test older versions of RSpec.
module RakeLastCommentWorkaround
  def last_comment
    last_description
  end
end

Rake::Application.send :include, RakeLastCommentWorkaround
# --- End of workaround


RSpec::Core::RakeTask.new(:spec)

task default: :spec
