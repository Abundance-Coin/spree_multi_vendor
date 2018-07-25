module Spree
  module Admin
    class VendorInventoryController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor
      before_action :load_and_validate_file, only: :upload, if: -> { request.post? }

      def index
        @collection = Spree::Variant.where(vendor_id: current_spree_vendor.id)
                                    .includes(:product)
                                    .joins(:stock_items)
                                    .group('spree_variants.id')
                                    .select('spree_variants.*, sum(spree_stock_items.count_on_hand) as count_on_hand')
                                    .page(params[:page])
                                    .per(params[:per_page] || 15)
      end

      def upload
        if request.post?
          options = {
            format: file_format,
            file_path: @file_path,
            product_type: upload_params[:product_type],
            provider: upload_params[:provider],
            vendor_id: @vendor.id
          }.merge(additional_inventory_params)

          upload = Inventory::UploadFileAction.call(options)

          if (errors = upload[:errors]).blank?
            flash[:success] = Spree.t(:vendor_inventory_success)
            return redirect_to admin_uploads_path
          else
            flash[:error] = errors
          end

          redirect_to admin_vendor_inventory_upload_path
        else
          render :upload
        end
      end

      private

      def authorize
        authorize!(:manage, :vendor_inventory)
      end

      def load_vendor
        @vendor = current_spree_vendor
      end

      def load_and_validate_file
        if (@attachment = upload_params['attachment']).present?
          save_content
        else
          flash[:error] = Spree.t(:vendor_inventory_blank)
          redirect_to admin_vendor_inventory_upload_path
        end
      end

      def save_content
        FileUtils.mkdir_p('tmp/uploads')
        @file_path = File.join('tmp', 'uploads', SecureRandom.urlsafe_base64)
        FileUtils.move(@attachment.tempfile.path, @file_path)
      end

      def additional_inventory_params
        {}
      end

      def upload_params
        params.fetch(:inventory, {}).permit(:attachment, :product_type, :provider)
      end

      def file_format
        @attachment.content_type.split('/').last
      end
    end
  end
end
