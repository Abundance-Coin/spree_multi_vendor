module Spree
  class VendorsController < Spree::StoreController
    include Spree::ProductsHelper

    helper_method :cache_key_for_product # not inclusion causes exception in product partial

    before_action :load_vendor, only: [:show]

    respond_to :html

    def show
      @products = @vendor.products
                         .distinct
                         .page(params[:page])
                         .per(Spree::Config[:products_per_page])
    end

    private

    def load_vendor
      @vendor = Spree::Vendor.friendly.find(params[:id])
    end
  end
end
