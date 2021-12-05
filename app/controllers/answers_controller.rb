class AnswersController < ApplicationController

  def show
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
  end
end
