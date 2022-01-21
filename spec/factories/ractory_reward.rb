# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    file_path = "#{Rails.root}/app/assets/images/reward_img.png"

    name { 'MyReward' }
    association(:question)
    after :create do |reward|
      reward.image.attach(io: File.open(file_path), filename: 'reward_img.png')
    end
  end
end
