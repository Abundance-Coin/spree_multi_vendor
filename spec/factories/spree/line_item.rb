FactoryBot.modify do
  factory :line_item do
    transient do
      vendor nil
    end
    variant do
      create(:variant, is_master: false,
                       product: product,
                       vendor: vendor || create(:vendor),
                       count_on_hand: quantity
      )
    end
  end
end
