# frozen_string_literal: true

class NotifyAboutNewAnswerMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end
