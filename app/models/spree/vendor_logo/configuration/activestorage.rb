module Spree
  class VendorLogo < Asset
    module Configuration
      module ActiveStorage
        extend ActiveSupport::Concern

        included do
          validate :check_attachment_content_type

          has_one_attached :attachment

          def self.styles
            @styles ||= {
              thumb: '180x180>',
              medium: '320x320>'
            }
          end

          def placeholder(_style)
            'vendors/logo.png'
          end

          def accepted_image_types
            %w[image/jpeg image/jpg image/png]
          end

          def check_attachment_content_type
            return if !attachment.attached? || !attachment.content_type.in?(accepted_image_types)

            errors.add(:attachment, :not_allowed_content_type)
          end
        end
      end
    end
  end
end
