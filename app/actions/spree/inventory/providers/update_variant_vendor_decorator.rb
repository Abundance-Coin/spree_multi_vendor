module Spree
  module Inventory
    module Providers
      module UpdateVariantVendorDecorator
        def update_variant_hook(variant, item)
          variant.vendor_id = options[:vendor_id]
          super
        end

        def fetch_variant(product, item)
          Variant.unscoped.where(sku: item[:sku], product: product, vendor_id: options[:vendor_id]).first_or_initialize
        end
      end
    end
  end
end

Spree::Inventory::Providers::DefaultVariantProvider.prepend(Spree::Inventory::Providers::UpdateVariantVendorDecorator)
