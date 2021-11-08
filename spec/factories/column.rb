FactoryBot.define do
  factory :column do
    sequence(:title) { |n| "title column #{n}" }
    description { 'description column' }
  end
end