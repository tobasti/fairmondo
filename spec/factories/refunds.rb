FactoryGirl.define do
  factory :refund do
    reason 'Artikel ist nicht lieferbar'
    description 'a' * 160
    transaction { FactoryGirl.create :transaction_with_buyer, :old }

    trait :not_sold_transaction do
      transaction { FactoryGirl.create :single_transaction }
    end
  end
end