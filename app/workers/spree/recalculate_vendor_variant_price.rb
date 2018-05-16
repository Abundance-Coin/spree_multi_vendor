module Spree
  class RecalculateVendorVariantPrice
    include Sidekiq::Worker

    sidekiq_options unique: :until_executed

    def perform(variant_id)
      return if (variant = Spree::Variant.find_by(id: variant_id)).blank?

      variant.adjust_price!
    end
  end
end
