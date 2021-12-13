# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[create edit update]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[edit update destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    flash.now[:notice] = 'Answer successfully created' if @answer.save
  end

  def edit; end

  def update
    if current_user&.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.delete
      flash.now[:notice] = 'Your answer successfully deleted'
      @question = @answer.question
    end
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
