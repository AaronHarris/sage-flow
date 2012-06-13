require 'bundler/setup'
require 'active_model'
require 'sage_flow'


RSpec.configure do |config|
  # some (optional) config here
end


class FakeModel
  include ActiveModel::Validations
  include SageFlow
end