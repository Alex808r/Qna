# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let!(:question) { create(:question_factory, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }

  it 'factory should be valid' do
    # expect(user.valid?).to eq(true) аналогичная запись
    expect(question).to be_valid
  end

  describe 'associations' do
    # it {is_expected.to have_many(:answers)} # аналогичная запись
    it { should have_many(:answers) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'set best answer' do
    it 'set the best answer' do
      question.set_best_answer(question.answers.second)
      question.set_best_answer(question.answers.first)

      expect(question.best_answer).to eq(question.answers.first)
      expect(question.best_answer).to_not eq(question.answers.second)
    end
  end

  describe 'database' do
    it { should have_db_index(:best_answer_id) }
    it { should have_db_column(:best_answer_id).with_options(null: true) }
    it { should have_db_column(:best_answer_id).of_type(:integer) }
    it { should have_db_column(:user_id).with_options(null: false) }
  end
end
