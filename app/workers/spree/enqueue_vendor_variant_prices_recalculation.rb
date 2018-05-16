module Spree
  class EnqueueVendorVariantPricesRecalculation
    include Sidekiq::Worker

    sidekiq_options unique: :until_executed

    def perform(vendor_id)
      return if (vendor = Spree::Vendor.find_by(id: vendor_id)).blank?

      vendor.variants.where(is_master: false).select(:id).find_in_batches do |variants|
        args = variants.map { |obj| [obj.id] }
        Sidekiq::Client.push_bulk('class' => Spree::RecalculateVendorVariantPrice, 'args' => args)
      end
    end
  end
end
