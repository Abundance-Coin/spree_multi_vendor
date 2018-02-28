module Spree
  module Inventory
    module Providers
      module UpdateVariantVendorDecorator
        def update_variant_hook(variant, item)
          variant.vendor_id = options[:vendor_id]
          super
        end
      end
    end
  end
end

Spree::Inventory::Providers::DefaultVariantProvider.prepend(Spree::Inventory::Providers::UpdateVariantVendorDecorator)
