# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  let(:question) { create(:question_factory) }
  let(:reward) { create(:reward, question: question) }

  it 'factory should be valid' do
    expect(reward).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'database' do
    it { should have_db_index(:user_id) }
    it { should have_db_index(:question_id) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:question_id).of_type(:integer) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  it 'has one attached file' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
