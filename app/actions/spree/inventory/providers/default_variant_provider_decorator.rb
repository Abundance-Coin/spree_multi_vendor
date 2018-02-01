Spree::Inventory::Providers::DefaultVariantProvider.class_eval do
  def update_variant_hook(variant)
    variant.vendor_id = options[:vendor_id]
  end
end
