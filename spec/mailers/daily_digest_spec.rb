# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:yesterday_questions) { create_list(:question_factory, 2, :yesterday, user: user) }
    let!(:not_yesterday_questions) { create_list(:question_factory, 2, :one_day_before_yesterday, user: user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi it is a DailyDigest')
    end

    it 'renders yesterday questions' do
      yesterday_questions.each do |question|
        within mail.body.to_s do
          expect(mail.body.encoded).to have_content question.title
        end
      end
    end

    it 'not renders questions one day before yesterday' do
      not_yesterday_questions.each do |question|
        within mail.body.to_s do
          expect(mail.body.encoded).to_not have_content question.title
        end
      end
    end
  end
end
