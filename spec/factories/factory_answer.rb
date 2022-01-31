# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer Body N: #{n}"
  end
  factory :answer do
    # association(:question)
    association :question, factory: :question_factory
    association(:user)
    title { 'MyAnswer' }
    body

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"

      after :create do |answer|
        answer.files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
        # create(:link, linkable: answer)
      end
    end

    trait :with_link do
      after :create do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end
