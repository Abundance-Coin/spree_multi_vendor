module Spree
  module Admin
    class VendorsController < ResourceController
      custom_callback(:create).before(:build_logo)
      custom_callback(:update).before(:build_logo)

      private

      def find_resource
        Vendor.friendly.find(params[:id])
      end

      def build_logo
        return if params[:logo].blank?

        @object.build_logo(attachment: permitted_logo_params[:logo])
      end

      def permitted_logo_params
        params.permit(:logo)
      end

      def collection
        params[:q] = {} if params[:q].blank?
        vendors = super.order(name: :asc)
        @search = vendors.ransack(params[:q])

        @collection = @search.result
                             .page(params[:page])
                             .per(params[:per_page])
      end
    end
  end
end
