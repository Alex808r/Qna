# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions

    # render json: @questions.to_json(include: :answers) без Serializers
  end
end
