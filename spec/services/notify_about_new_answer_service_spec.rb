# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyAboutNewAnswerService do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends notifications all subscribe users' do
    NotifyAboutNewAnswerService.new(answer).send_notification
  end
end
