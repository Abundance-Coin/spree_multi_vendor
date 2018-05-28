FactoryBot.define do
  factory :price_markup, class: Spree::PriceMarkup do
    name { FFaker::Company.name }
    amount { rand(100) }
  end
end
