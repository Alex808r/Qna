# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:question) { create(:question_factory) }
  let(:answer) { build(:answer, question: question) }
  let(:vote_with_question) { create(:vote, votable: question) }
  let(:vote_with_answer) { create(:vote, votable: answer) }

  it 'factory should be valid with question' do
    expect(vote_with_question).to be_valid
  end

  it 'factory should be valid with answer' do
    expect(vote_with_answer).to be_valid
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'validations' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user }
  end

  describe 'database' do
    it { should have_db_index(%i[votable_type votable_id]) }
    it { should have_db_column(:votable_id).of_type(:integer) }
    it { should have_db_column(:votable_type).of_type(:string) }
  end

  describe 'polymorphic' do
    it { should respond_to(:value) }
    it { should respond_to(:user) }
    it { should respond_to(:votable) }
    it { expect(vote_with_question.votable).to eq question }
    it { expect(vote_with_answer.votable).to eq answer }
  end
end
