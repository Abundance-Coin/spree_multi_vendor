module Spree
  module UploadInventoryWorkerDecorator
    def options
      super.merge(vendor_id: @upload.vendor_id)
    end
  end

  UploadInventoryWorker.prepend(UploadInventoryWorkerDecorator)
end
