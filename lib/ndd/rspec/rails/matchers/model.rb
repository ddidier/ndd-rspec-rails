require_relative 'model/have_a_translated_model'

RSpec.configure do |config|
  config.include Ndd::RSpec::Rails::Matchers::Model, type: :model
end
