# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions

    # render json: @questions.to_json(include: :answers) без Serializers
  end

  def show
    render json: @question, serializer: QuestionWithAssociationSerializer
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, status: :accepted
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question

    @question.destroy
    render json: { messages: ['Your question successfully deleted'] }
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
