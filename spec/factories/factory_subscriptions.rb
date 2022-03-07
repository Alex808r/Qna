# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :user
    association :question, factory: :question_factory
  end
end
