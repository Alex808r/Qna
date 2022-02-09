# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user

    body { 'MyComment' }
  end
end
