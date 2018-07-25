module Spree
  module Api
    module V1
      module InventoryControllerDecorator
        private

        def additional_inventory_params
          { vendor_id: current_vendor&.id }
        end

        def current_vendor
          current_api_user.vendors.first if !current_api_user.respond_to?(:has_spree_role?) || !current_api_user.has_spree_role?(:admin)
        end
      end

      InventoryController.prepend(InventoryControllerDecorator)
    end
  end
end
