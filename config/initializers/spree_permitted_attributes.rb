module Spree
  module PermittedAttributes
    ATTRIBUTES << :vendor_attributes

    mattr_reader :vendor_attributes

    @@vendor_attributes = %i[name customer_support_email note] # rubocop:disable Style/ClassVars
  end
end
