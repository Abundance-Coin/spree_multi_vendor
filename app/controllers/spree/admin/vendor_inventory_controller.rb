module Spree
  module Admin
    class VendorInventoryController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor
      before_action :load_and_validate_file, only: :upload

      def upload
        upload = Inventory::UploadFileAction.call(file_format, @file_path, upload_options: { vendor_id: @vendor.id })

        if (errors = upload[:errors]).blank?
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
        if (@attachment = inventory_params['attachment']).present?
          save_content
        else
          flash[:error] = Spree.t(:vendor_inventory_blank)
          redirect_to admin_vendor_inventory_path
        end
      end

      def save_content
        @file_path = File.join('tmp', 'uploads', SecureRandom.urlsafe_base64)
        FileUtils.move(@attachment.tempfile.path, @file_path)
      end

      def inventory_params
        params.fetch(:inventory, {}).permit(:attachment)
      end

      def file_format
        @attachment.content_type.split('/').last
      end
    end
  end
end
