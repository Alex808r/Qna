# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :menage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :menage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question_factory, user: user) }
    let(:other_question) { create(:question_factory, user: other) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: other_question, user: other) }

    context 'with all objects' do
      it { should be_able_to :read, :all }
      it { should_not be_able_to :menage, :all }
    end

    context 'attach file' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
      it { should_not be_able_to :menage, ActiveStorage::Attachment }
    end

    context 'create objects' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create_comment, Question }
      it { should be_able_to :create_comment, Answer }
    end

    context 'update only own objects' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }
    end

    context 'destroy only own objects' do
      it { should be_able_to :destroy, Question }
      it { should be_able_to :destroy, Answer }

      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }
    end

    context 'vote only other objects' do
      it { should be_able_to %i[vote_up vote_down vote_cancel], other_question }
      it { should_not be_able_to %i[vote_up vote_down vote_cancel], question }

      it { should be_able_to %i[vote_up vote_down vote_cancel], other_answer }
      it { should_not be_able_to %i[vote_up vote_down vote_cancel], answer }
    end

    context 'set best answer' do
      it { should be_able_to :best_answer, answer }
      it { should_not be_able_to :best_answer, other_answer }
    end
  end
end
