module Spree
  module Admin
    class VendorInventoryController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor
      before_action :load_and_validate_file, only: :upload

      def upload
        file_format = extract_content_format(@file.content_type)
        @upload = Inventory::UploadFileAction.call(file_format, @file.path, upload_options: { vendor_id: @vendor.id })

        if (errors = @upload[:errors]).blank?
          flash[:success] = Spree.t(:vendor_inventory_success)
          return redirect_to admin_uploads_path
        else
          flash[:error] = errors
        end

        redirect_to admin_vendor_inventory_path
      end

      private

      def authorize
        authorize!(:manage, :vendor_inventory)
      end

      def load_vendor
        @vendor = current_spree_vendor
      end

      def load_and_validate_file
        return if (@file = inventory_params['attachment']).present?
        flash[:error] = Spree.t(:vendor_inventory_blank)
        redirect_to admin_vendor_inventory_path
      end

      def inventory_params
        params.fetch(:inventory, {}).permit(:attachment)
      end

      def extract_content_format(content_type)
        content_type.split('/').last
      end
    end
  end
end
