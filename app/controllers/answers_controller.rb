# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[create edit update]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[edit update destroy best_answer]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    flash.now[:notice] = 'Answer successfully created' if @answer.save
    # respond_to do |format|
    #   if @answer.save
    #     format.json { render json: @answer }
    #   else
    #     format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
    #   end
    # end
  end

  def edit; end

  def update
    return unless authorize! :update, @answer

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    # return unless current_user&.author?(@answer)
    return unless authorize! :destroy, @answer

    @answer.delete
    @question = @answer.question
    flash.now[:notice] = 'Your answer successfully deleted'
  end

  def best_answer
    @question = @answer.question
    # return unless current_user&.author?(@question)
    return unless authorize! :best_answer, @answer

    @question.set_best_answer(@answer)

    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body, files: [],
                                                  links_attributes: %i[name url _destroy id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    # @answer = @question.answers.find(params[:id])
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers/#{params[:question_id]}",
                                 ApplicationController.render(
                                   partial: 'answers/answer_channel',
                                   locals: { question: @answer.question, answer: @answer, current_user: current_user }
                                 ))
  end
end
