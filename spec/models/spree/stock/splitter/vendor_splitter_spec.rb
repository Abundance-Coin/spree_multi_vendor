require 'spec_helper'

describe Spree::Stock::Splitter::VendorSplitter, type: :model do
  subject(:result) do
    described_class.new(packer).split(packages)
  end

  let(:packer) { build(:stock_packer) }

  let(:packages) { [package1] }
  let(:package1) { Spree::Stock::Package.new(packer.stock_location) }

  let(:variant1) { create(:variant, vendor: vendor1) }
  let(:vendor1) { create(:vendor) }
  let(:variant2) { create(:variant, vendor: vendor2) }
  let(:vendor2) { create(:vendor) }

  # these inventory_unit methods are working 2x faster than build_stubbed
  def inventory_unit1
    Spree::InventoryUnit.new(variant: variant1)
  end

  def inventory_unit2
    Spree::InventoryUnit.new(variant: variant2)
  end

  before do
    4.times { package1.add(inventory_unit1) }
    8.times { package1.add(inventory_unit2) }
  end

  context 'with one package' do
    it 'contains correct number of packages' do
      expect(result.size).to eq 2
    end

    it 'splits each package by vendor' do
      expect(result[0].quantity).to eq 4
      expect(result[1].quantity).to eq 8
    end
  end

  context 'with multiple packages' do
    let(:package2) { Spree::Stock::Package.new(packer.stock_location) }
    let(:packages) { [package1, package2] }

    before do
      6.times { package2.add(inventory_unit1) }
      9.times { package2.add(inventory_unit2, :backordered) }
    end

    it 'contains correct number of packages' do
      expect(result.size).to eq 4
    end

    it 'splits each package by vendor' do
      expect(result[0].quantity).to eq 4
      expect(result[1].quantity).to eq 8
      expect(result[2].quantity).to eq 6
      expect(result[3].quantity).to eq 9
    end
  end
end
