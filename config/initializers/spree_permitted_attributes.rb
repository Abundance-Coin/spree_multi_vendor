module Spree
  module PermittedAttributes
    ATTRIBUTES << :vendor_attributes

    mattr_reader(*ATTRIBUTES)

    def self.vendor_attributes
      %i[name note]
    end
  end
end
