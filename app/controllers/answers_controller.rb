# frozen_string_literal: true

class AnswersController < ApplicationController

  def show
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
  end

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
  end

  def update
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    @answer.update(answer_params)
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
