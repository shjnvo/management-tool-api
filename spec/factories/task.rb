FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title task #{n}" }
    description { 'description task' }
  end
end