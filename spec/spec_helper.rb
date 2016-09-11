require 'griddler/testing'
require 'griddler/sendgrid'
require 'action_dispatch'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.include Griddler::Testing
  config.expect_with(:rspec) do |c|
    c.syntax = [:should, :expect]
  end
end
