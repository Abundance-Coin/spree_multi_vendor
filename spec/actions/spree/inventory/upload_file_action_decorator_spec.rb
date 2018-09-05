RSpec.describe Spree::Inventory::UploadFileAction, type: :action do
  subject(:upload) { described_class.call(options) }

  let(:vendor) { create(:vendor) }
  let(:options) do
    {
      format: 'csv',
      file_path: 'fakepath',
      product_type: 'fake',
      vendor_id: vendor.id
    }
  end

  it 'sets vendor_id' do
    expect(upload.vendor).not_to be nil
  end
end
