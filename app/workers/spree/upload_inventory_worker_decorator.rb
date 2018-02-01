Spree::UploadInventoryWorker.class_eval do
  def options
    { vendor_id: @upload.vendor_id }
  end
end
