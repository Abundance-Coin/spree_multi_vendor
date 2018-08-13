class AddSlugToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_vendors, :slug, :string

    Spree::Vendor.reset_column_information
    Spree::Vendor.find_each(&:save!)
  end
end
