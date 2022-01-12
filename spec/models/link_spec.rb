# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question) { create(:question_factory) }
  let(:links) { create(:link, linkable: question) }
  let(:invalid_links) { build(:link, :invalid, linkable: question) }

  # валидна ли фабрика
  it 'factory should be valid' do
    expect(links).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }

    it 'valid url' do
      expect(links).to be_valid
    end

    it 'invalid url' do
      expect(invalid_links).to_not be_valid
    end
  end

  describe 'database' do
    it { should have_db_index(%i[linkable_type linkable_id]) }
    it { should have_db_column(:linkable_id).of_type(:integer) }
    it { should have_db_column(:linkable_type).of_type(:string) }
  end
end
