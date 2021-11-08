FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "title project #{n}" }
    description { 'description project' }
  end
end