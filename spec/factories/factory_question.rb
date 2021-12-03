# frozen_string_literal: true

FactoryBot.define do
  factory :question_factory, class: Question do
    title { 'MyString' }
    body { 'MyText' }
  end

  trait :invalid do
    title { nil }
  end
end
