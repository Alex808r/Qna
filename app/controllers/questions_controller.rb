# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.delete
    redirect_to questions_path
  end

  private

  def set_question
    @question =  Question.find(params[:id])
    # @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end
  
  # helper_method :set_question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
