module Spree
  class RecalculateVendorVariantPrices
    include Sidekiq::Worker

    sidekiq_options unique: :until_executed

    def perform(vendor_id)
      return if (vendor = Spree::Vendor.find_by(id: vendor_id)).blank?

      vendor.variants.includes(:default_price).find_each(&:adjust_price!)
    end
  end
end
