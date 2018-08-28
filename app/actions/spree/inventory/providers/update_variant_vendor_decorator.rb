module Spree
  module Inventory
    module Providers
      module UpdateVariantVendorDecorator
        def update_variant_hook(variant, item)
          variant.vendor_id = options[:vendor_id]
          super
        end

        def find_variant(sku)
          Variant.unscoped.find_by(sku: sku, vendor_id: options[:vendor_id])
        end
      end

      DefaultVariantProvider.prepend(UpdateVariantVendorDecorator)
    end
  end
end
