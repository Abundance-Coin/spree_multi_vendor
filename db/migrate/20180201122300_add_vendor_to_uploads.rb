class AddVendorToUploads < ActiveRecord::Migration[5.1]
  def change
    add_reference :spree_uploads, :vendor, index: true
  end
end
