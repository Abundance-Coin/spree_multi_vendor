Spree::Variant.class_eval do
  before_save :adjust_price, unless: :is_master

  def adjust_price
    return if cost_price.blank?
    self.price = cost_price
    self.price += vendor.price_markups.sum(:amount) if vendor.present?
  end

  def adjust_price!
    adjust_price
    save
  end

  private

  def create_stock_items
    Spree:: StockLocation.where(propagate_all_variants: true, vendor_id: vendor_id).find_each do |stock_location|
      stock_location.propagate_variant(self)
    end
  end
end
