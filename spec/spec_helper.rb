require 'griddler/sendgrid'
require 'action_dispatch'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

module Griddler::FixturesHelper
  def fixture_file(file_name)
    cwd = File.expand_path File.dirname(__FILE__)
    File.new(File.join(cwd, 'fixtures', file_name))
  end
end
