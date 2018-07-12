RSpec.configure do |config|
  config.before do
    allow_any_instance_of(Spree::Inventory::Providers::Fake::MetadataProvider).to receive(:images).and_return nil
  end
end
