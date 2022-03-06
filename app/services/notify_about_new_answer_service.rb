# frozen_string_literal: true

class NotifyAboutNewAnswerService
  attr_reader :answer

  def initialize(answer)
    @answer = answer
  end

  def send_notification
    @question = @answer.question
    @question.subscriptions.find_each(batch_size: 500) do |subscription|
      NotifyAboutNewAnswerMailer.notify(subscription.user, @answer).deliver_later
    end
  end
end
