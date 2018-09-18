module Spree
  module Admin
    class VendorBankController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor
      before_action :load_data

      def edit
        @bank_account = @vendor.bank_account
      end

      def update
        @bank_account = @vendor.bank_account
        @bank_account.assign_attributes(bank_params.merge(request_ip: request.remote_ip))

        if @bank_account.valid? && @bank_account.save
          @vendor.update(gateway_account_profile_id: @bank_account.account_id)
        end

        render :edit
      end

      private

      def authorize
        authorize! :manage, :vendor_bank
      end

      def load_vendor
        @vendor = current_spree_vendor
      end

      def load_data
        @account_types = [%w[Company company], %w[Individual individual]]
        @stripe_key = Spree::BankAccount.stripe_key
      end

      def bank_params
        params.require(:bank_account)
              .permit(:city, :first_name, :last_name, :line1, :line2,
                      :postal_code, :state, :business_name, :email, :tos_acceptance,
                      :dob, :ssn, :account_holder_type, :token, :document_file, :tax_id)
      end
    end
  end
end
