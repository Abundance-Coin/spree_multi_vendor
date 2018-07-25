module Spree
  module Inventory
    module UploadFileActionDecorator
      def upload_options
        { vendor_id: upload_meta.delete(:vendor_id) }
      end
    end

    UploadFileAction.prepend(UploadFileActionDecorator)
  end
end
