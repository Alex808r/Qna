# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
    let(:question) { create(:question_factory) }
    let(:answer) { create(:answer, question: question) }

  describe 'GET #show' do
    before { get :show, params: {id: answer, question_id: question } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
      before { get :new, params: { question_id: question } }

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a(Answer)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(Answer, :count).by(1)
        end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to (assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }
        .not_to change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: {id: answer, question_id: question } }

    it 'change the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end

  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { title: 'new answer', body: 'new answer' } }
        answer.reload
        expect(answer.title).to eq 'new answer'
        expect(answer.body).to eq 'new answer'
      end

      it 'redirect to updated answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
        answer.reload
        expect(answer.title).to eq 'MyAnswer'
        expect(answer.body).to eq 'MyAnswer'
      end

      it 're-renders edit view' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end
end
