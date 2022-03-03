# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[ index show update destroy ]
  before_action :set_answer, only: %i[ show update destroy ]
  
  def index
    @question = Question.includes(:answers)
    render json: @question
  end
  
  def show
    render json: @answer, serializer: AnswerWithAssociationSerializer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
  
  def set_question
    @question = Question.find(params[:question_id])
  end
  
  def set_answer
    @answer = Answer.find(params[:id])
  end
end
