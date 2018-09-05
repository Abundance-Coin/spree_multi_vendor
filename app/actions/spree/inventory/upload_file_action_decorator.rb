module Spree
  module Inventory
    module UploadFileActionDecorator
      def upload_options
        @upload_options ||= { vendor_id: upload_meta.delete(:vendor_id) }
      end

      def queue_name
        slug = Spree::Vendor.find(upload_options[:vendor_id]).slug
        "#{slug}-uploads"
      end
    end

    UploadFileAction.prepend(UploadFileActionDecorator)
  end
end
