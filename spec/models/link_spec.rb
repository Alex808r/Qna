# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question) { create(:question_factory) }
  let(:links) { create(:link, linkable: question) }
  let(:invalid_links) { build(:link, :invalid, linkable: question) }
  let(:gist_link) { create(:link, :with_gist, linkable: question) }

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

  describe 'polymorphic' do
    it { should respond_to(:url) }
    it { should respond_to(:name) }
    it { should respond_to(:linkable) }
    it { expect(links.linkable).to eq question }
  end
  
  describe 'link' do
    it 'has gist' do
      expect(gist_link.gist?).to be_truthy # or be true
    end

    it 'has not gist' do
      expect(links.gist?).to be_falsey # or be fasle
    end
  end
end
