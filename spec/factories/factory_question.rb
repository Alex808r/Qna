# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Title question N: #{n}"
  end
  
  factory :question_factory, class: Question do
    title
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end
  end
end
