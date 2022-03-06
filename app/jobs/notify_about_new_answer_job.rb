# frozen_string_literal: true

class NotifyAboutNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(new_answer)
    NotifyAboutNewAnswerService.new(new_answer).send_notification
  end
end
