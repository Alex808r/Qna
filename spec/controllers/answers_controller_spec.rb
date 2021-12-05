# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
    let(:question) { create(:question_factory) }
    let(:answer) { create(:answer, question: question) }

  describe 'GET #show' do
    before { get :show, params: {id: answer, question_id: question } }

    it 'assigns the requested answer to @answer' do
      get :show, params: { id: answer, question_id: question }
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
  


end
