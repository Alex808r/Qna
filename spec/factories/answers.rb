# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    title { 'MyString' }
    body { 'MyText' }
    question { nil }
  end
end
