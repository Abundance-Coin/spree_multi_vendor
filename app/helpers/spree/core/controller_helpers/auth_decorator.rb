Spree::Core::ControllerHelpers::Auth.class_eval do
  include Spree::VendorHelper

  def self.included(base)
    base.helper_method :current_spree_vendor
  end
end
