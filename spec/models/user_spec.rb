# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'method author' do
    let(:it_is_author) { create(:user) }
    let(:not_author) { create(:user) }
    let(:question) { create(:question_factory, user: it_is_author) }

    it 'user is author' do
      expect(it_is_author).to be_author(question)
    end

    it 'user is not author' do
      expect(not_author).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'method subscribed?' do
    let(:it_is_author) { create(:user) }
    let(:not_author) { create(:user) }
    let(:question) { create(:question_factory, user: it_is_author) }
    let!(:subscription) { create(:subscription, question: question, user: it_is_author) }

    it 'author question have subscribed' do
      expect(it_is_author).to be_subscribed(question)
    end

    it 'did not subscribe if not author' do
      expect(not_author).to_not be_subscribed(question)
    end
  end
end
