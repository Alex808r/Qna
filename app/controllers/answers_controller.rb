# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[create edit update]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[edit update destroy best_answer]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    flash.now[:notice] = 'Answer successfully created' if @answer.save
  end

  def edit; end

  def update
    return unless current_user&.author?(@answer)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    return unless current_user&.author?(@answer)

    @answer.delete
    @question = @answer.question
    flash.now[:notice] = 'Your answer successfully deleted'
  end
  
  def best_answer
    @question = @answer.question
    return unless current_user&.author?(@question)
    @question.update(best_answer_id: @answer.id)
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    # @answer = @question.answers.find(params[:id])
    @answer = Answer.find(params[:id])
  end
end
