Spree::Admin::PropertiesController.class_eval do
  before_action :set_vendor_id, only: %i[create update]
end
