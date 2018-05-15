module Spree
  class PriceMarkup < Spree::Base
    belongs_to :vendor

    validates :name, :amount, presence: true
  end
end
