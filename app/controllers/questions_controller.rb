# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer)
  end

  def new
    @question = current_user.questions.new
    @question.links.build
    @question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return unless current_user&.author?(@question)

    @question.update(question_params)
    flash.now[:notice] = 'Your question successfully updated.'
  end

  def destroy
    if current_user.author?(@question)
      @question.delete
      redirect_to questions_path, notice: 'Your question successfully deleted'
    else
      redirect_to @question, notice: 'Cannot be deleted. You are not the author of the question.'
    end
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      ApplicationController.render(
        partial: 'questions/question_channel',
        locals: { question: @question }
      )
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
    # @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end
  # helper_method :set_question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url _destroy id],
                                                    reward_attributes: %i[name image])
  end
end
