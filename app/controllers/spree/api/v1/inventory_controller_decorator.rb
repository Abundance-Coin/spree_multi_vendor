Spree::Api::V1::InventoryController.class_eval do
  def update
    authorize! :create, Spree::Product

    options = { upload_options: { vendor_id: current_vendor&.id }}

    if (product_type = params[:product_type])
      options[:product_type] = product_type
    end

    file_path = save_content
    @upload = Spree::Inventory::UploadFileAction.call(params[:content_format], file_path, options)
  end

  private

  def current_vendor
    current_api_user.vendors.first if !current_api_user.respond_to?(:has_spree_role?) || !current_api_user.has_spree_role?(:admin)
  end
end
