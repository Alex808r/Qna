# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[create]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[edit update destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Answer successfully created'
    else
      render 'questions/show'
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.delete
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted'
    else
      redirect_to question_path(@answer.question), notice: 'Cannot be deleted. You are not the author of the answer.'
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
