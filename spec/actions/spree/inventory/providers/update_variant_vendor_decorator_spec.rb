RSpec.describe Spree::Inventory::Providers::UpdateVariantVendorDecorator, type: :action do
  subject(:variant) { Spree::Inventory::Providers::DefaultVariantProvider.call(item_json, options: options) }

  let(:vendor) { create(:vendor) }
  let(:options) { { vendor_id: vendor.id } }
  let(:item_json) do
    {
      ean: '9780979728303',
      sku: '08-F-002387',
      condition: 'Acceptable'
    }
  end

  describe '#update_variant_hook' do
    it 'sets vendor to variant' do
      expect(variant.vendor_id).to eq(options[:vendor_id])
    end
  end
end
