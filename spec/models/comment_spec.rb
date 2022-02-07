# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:question) { create(:question_factory) }
  let(:comment_to_question) { create(:comment, commentable: question) }
  let(:answer) { create(:answer, question: question) }
  let(:comment_to_answer) { create(:comment, commentable: answer) }

  it 'factory should be valid' do
    expect(comment_to_question).to be_valid
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to(:commentable) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user }
  end

  describe 'polymorphic' do
    it { should respond_to(:body) }
    it { should respond_to(:user) }
    it { should respond_to(:commentable) }
    it { expect(comment_to_question.commentable).to eq question }
    it { expect(comment_to_answer.commentable).to eq answer }
  end

  describe 'database' do
    it { should have_db_index(%i[commentable_type commentable_id]) }
    it { should have_db_index(:user_id) }
    it { should have_db_column(:commentable_id).of_type(:integer) }
    it { should have_db_column(:commentable_type).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:body).of_type(:string) }
  end
end
