# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question_factory) }

  it 'calls Services::Reputation#calculate' do
    expect(ReputationService).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
