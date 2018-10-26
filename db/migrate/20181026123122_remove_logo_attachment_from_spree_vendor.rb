class RemoveLogoAttachmentFromSpreeVendor < ActiveRecord::Migration[5.2]
  class Spree::Vendor201826010 < ApplicationRecord
    self.table_name = :spree_vendors
    self.has_attached_file :logo, path: Paperclip::Attachment.default_options[:path].gsub(':class', 'spree/vendors')
  end

  class << self
    def up
      Spree::Vendor201826010.find_each do |v|
        next if v.logo_file_name.blank?

        Spree::Vendor.find(v.id).create_logo(attachment: URI.parse(v.logo.url))
      end

      remove_attachment :spree_vendors, :logo
    end

    def down
      change_table :spree_vendors do |t|
        t.attachment :image
      end
    end
  end
end
