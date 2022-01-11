# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question) { create(:question_factory) }
  let(:links) { create(:link, question: question) }

  # валидна ли фабрика
  it 'factory should be valid' do
    expect(links).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end

  describe 'database' do
    it { should have_db_index(:question_id) }
    it { should have_db_column(:question_id).of_type(:integer) }
  end
end
