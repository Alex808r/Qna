# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "user#{n}@test.com"
  end
  
  factory :question_factory, class: Question do
    title
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end
  end
end
