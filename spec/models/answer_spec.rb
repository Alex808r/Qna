# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:question) { create(:question_factory) }
  let(:answer) { build(:answer, question: question) }

  it_behaves_like 'votable_object'

  # валидна ли фабрика
  it 'factory should be valid' do
    expect(answer).to be_valid
  end

  describe 'have nested links' do
    it { should accept_nested_attributes_for :links }
  end

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
  end

  describe 'database' do
    it { should have_db_index(:question_id) }
    it { should have_db_column(:question_id).with_options(null: false) }
    it { should have_db_column(:question_id).of_type(:integer) }
  end
end
