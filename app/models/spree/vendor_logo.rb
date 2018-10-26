module Spree
  class VendorLogo < Asset
    include Rails.application.config.use_paperclip ? Configuration::Paperclip : Configuration::ActiveStorage
  end
end
