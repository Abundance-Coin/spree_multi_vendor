require 'factory_bot'
require 'spree/testing_support/factories'
require 'spree_multi_vendor/factories'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
