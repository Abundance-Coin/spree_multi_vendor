module Spree
  module Stock
    module Splitter
      class VendorSplitter < Spree::Stock::Splitter::Base
        def split(packages)
          split_packages = packages.flat_map(&method(:split_by_vendor))
          return_next(split_packages)
        end

        private

        def split_by_vendor(package)
          # group package items by vendor
          grouped_packages = package.contents.group_by(&method(:vendor_for_item))
          hash_to_packages(grouped_packages)
        end

        def hash_to_packages(grouped_packages)
          # select values from packages grouped by vendors and build new packages
          grouped_packages.values.map(&method(:build_package))
        end

        # optimization: save variant -> vendor correspondence
        def vendor_for_item(item)
          @item_vendor ||= {}
          @item_vendor[item.inventory_unit.variant_id] ||= item.variant.vendor_id
        end
      end
    end
  end
end
