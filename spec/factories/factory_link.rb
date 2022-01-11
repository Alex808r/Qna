# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association(:linkable)
    name { 'MyString' }
    url { 'MyString' }
  end
end
