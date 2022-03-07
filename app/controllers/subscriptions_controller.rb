# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  before_action :set_question, only: :create

  def create
    @subscription = @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
