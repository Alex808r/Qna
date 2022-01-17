# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    name { 'MyReward' }
    association(:question)
  end
end
