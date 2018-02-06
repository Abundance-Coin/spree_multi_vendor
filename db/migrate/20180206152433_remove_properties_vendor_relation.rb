class RemovePropertiesVendorRelation < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_properties, :vendor_id
  end
end
