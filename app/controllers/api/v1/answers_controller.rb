# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show update destroy]

  def index
    @question = Question.includes(:answers)
    render json: @question
  end

  def show
    render json: @answer, serializer: AnswerWithAssociationSerializer
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer

    if @answer.update(answer_params)
      render json: @answer, status: :accepted
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer

    @answer.destroy
    render json: { messages: ['Your answer successfully deleted'] }
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
