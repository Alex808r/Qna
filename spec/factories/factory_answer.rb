# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association(:question)
    title { 'MyString' }
    body { 'MyText' }
    question { nil }
  end
end
