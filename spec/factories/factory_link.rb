# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association(:linkable)
    name { 'MyString' }
    url { 'https://thinknetica.com' }

    trait :invalid do
      name { 'Invalid link' }
      url { 'Invalid link' }
    end

    trait :with_gist do
      url { 'https://gist.github.com' }
    end
  end
end
