FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Johnd #{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
  end
end