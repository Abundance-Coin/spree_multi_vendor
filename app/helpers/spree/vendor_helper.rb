module Spree
  module VendorHelper
    private

    def current_spree_vendor
      return unless current_spree_user
      # disallow current_spree_vendor to include admins
      current_spree_user.vendors.first if !current_spree_user.respond_to?(:has_spree_role?) || !current_spree_user.has_spree_role?(:admin)
    end
  end
end
