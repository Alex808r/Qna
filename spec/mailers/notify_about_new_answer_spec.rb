# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyAboutNewAnswerMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:subscription) { create(:subscription, question: question, user: user) }
  let(:mail) { NotifyAboutNewAnswerMailer.notify(user, answer) }

  it 'renders the headers' do
    expect(mail.subject).to eq('Notify')
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(['from@example.com'])
  end

  it 'renders the body' do
    expect(mail.body.encoded).to match(answer.body)
  end
end
