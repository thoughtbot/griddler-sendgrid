require 'griddler'
require 'griddler/sendgrid/version'
require 'griddler/sendgrid/adapter'

module Griddler
  module Sendgrid
  end
end

Griddler.adapter_registry.register(:sendgrid, Griddler::Sendgrid::Adapter)
