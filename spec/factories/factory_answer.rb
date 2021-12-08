# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer Body N: #{n}"
  end
  factory :answer do
    association(:question)
    association(:user)
    title { 'MyAnswer' }
    body

    trait :invalid do
      title { nil }
    end
  end
end
