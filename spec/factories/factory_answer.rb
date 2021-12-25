# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer Body N: #{n}"
  end
  factory :answer do
    association(:question)
    association(:user)
    title { 'MyAnswer' }
    body

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"
  
      after :create do |answer|
        answer.answer_files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
      end
    end
  end
end
