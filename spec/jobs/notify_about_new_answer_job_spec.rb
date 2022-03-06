# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyAboutNewAnswerJob, type: :job do
  let(:service) { double(NotifyAboutNewAnswerService) }
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before { allow(NotifyAboutNewAnswerService).to receive(:new).and_return(service) }

  it 'calls NotifyAboutNewAnswerService #notification' do
    expect(service).to receive(:send_notification)
    NotifyAboutNewAnswerJob.perform_now(answer)
  end
end
