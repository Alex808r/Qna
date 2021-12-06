# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { build(:question_factory) }

  it 'factory should be valid' do
    # expect(user.valid?).to eq(true) аналогичная запись
    expect(question).to be_valid
  end

  describe 'associations' do
    # it {is_expected.to have_many(:answers)} # аналогичная запись
    it { should have_many(:answers) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
