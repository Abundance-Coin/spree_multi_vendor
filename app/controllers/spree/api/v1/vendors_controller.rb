module Spree
  module Api
    module V1
      class VendorsController < Spree::Api::BaseController
        def index
          @vendors = Spree::Vendor.accessible_by(current_ability, :read).order('name ASC').ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
          respond_with(@vendors)
        end

        def show
          respond_with(vendor)
        end

        private

        def vendor
          @vendor ||= Spree::Vendor.accessible_by(current_ability, :read).find(params[:id])
        end
      end
    end
  end
end
