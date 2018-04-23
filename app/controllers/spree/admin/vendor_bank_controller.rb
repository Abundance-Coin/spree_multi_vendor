module Spree
  module Admin
    class VendorBankController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor
      before_action :load_data

      def update
      end

      private

      def authorize
        authorize! :manage, :vendor_bank
      end

      def load_vendor
        @vendor = current_spree_vendor
      end

      def load_data
        @account_types = [['Company', 'company'], ['Individual', 'individual']]
      end
    end
  end
end
