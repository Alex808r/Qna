# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show]

  def index
    @questions = Question.all
    render json: @questions

    # render json: @questions.to_json(include: :answers) без Serializers
  end

  def show
    render json: @question, serializer: QuestionWithAssociationSerializer
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
