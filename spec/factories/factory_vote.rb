# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association(:votable)
    association :user, factory: :user
    value { 0 }
    # association :votable, factory: :question_factory
  end
end
