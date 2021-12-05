# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association(:question)
    title { 'MyAnswer' }
    body { 'MyAnswer' }
    # question { :question_factory }

    trait :invalid do
      title { nil }
    end
  end
end
