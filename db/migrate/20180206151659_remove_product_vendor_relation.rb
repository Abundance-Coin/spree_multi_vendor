class RemoveProductVendorRelation < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_products, :vendor_id
  end
end
