module Spree
  class VendorLogo < Asset
    module Configuration
      module Paperclip
        extend ActiveSupport::Concern

        included do
          has_attached_file :attachment,
                            styles: { thumb: '180x180>', medium: '320x320>' },
                            default_url: 'vendors/logo.png'

          validates_attachment_content_type :attachment, content_type: %r{\Aimage\/.*\z}

          delegate :url, to: :attachment
        end
      end
    end
  end
end
