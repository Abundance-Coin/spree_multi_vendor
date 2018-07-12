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

      DefaultVariantProvider.prepend(UpdateVariantVendorDecorator)
    end
  end
end
