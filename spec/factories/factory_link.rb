# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association(:linkable)
    name { 'MyString' }
    url { 'https://thinknetica.com' }

    trait :invalid do
      name { 'MyString' }
      url { 'MyString' }
    end
  end
end
