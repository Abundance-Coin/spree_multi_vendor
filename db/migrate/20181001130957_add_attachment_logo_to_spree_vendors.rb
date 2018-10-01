class AddAttachmentLogoToSpreeVendors < ActiveRecord::Migration[5.2]
  def self.up
    change_table :spree_vendors do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :spree_vendors, :logo
  end
end
