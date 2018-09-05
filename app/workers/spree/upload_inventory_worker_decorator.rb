module Spree
  module UploadInventoryWorkerDecorator
    def options
      super.merge(vendor_id: @upload.vendor_id, queue_name: "#{@upload.vendor.slug}-uploads")
    end
  end

  UploadInventoryWorker.prepend(UploadInventoryWorkerDecorator)
end
