module Spree
  class VendorsController < Spree::StoreController
    include Spree::ProductsHelper

    helper_method :cache_key_for_product # not inclusion causes exception in product partial

    before_action :load_vendor, only: [:show]

    respond_to :html

    private

    def load_vendor
      @vendor = Spree::Vendor.find_by(id: params[:id])
    end
  end
end
