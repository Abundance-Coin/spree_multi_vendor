Spree::StockLocation.class_eval do
  private

  def create_stock_items
    Spree::Variant.includes(:product).where(vendor_id: vendor_id).find_each do |variant|
      propagate_variant(variant)
    end
  end
end
