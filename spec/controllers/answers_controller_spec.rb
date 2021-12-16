# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
          .to change(question.answers, :count).by(1)
      end

      it 'render template create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end
          .not_to change(Answer, :count)
      end

      it 're-renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: answer, question_id: question } }

    it 'change the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render template edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author update answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update,
                params: { question_id: question, id: answer, answer: { title: 'new answer', body: 'new answer' } },
                format: :js
          answer.reload
          expect(answer.title).to eq 'new answer'
          expect(answer.body).to eq 'new answer'
        end

        it 'render template update' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) },
                         format: :js
          answer.reload
          expect(answer.title).to eq 'MyAnswer'
        end

        it 're-renders template update' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) },
                         format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }
      before { login(not_author) }
      it 'tries to update answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

    context 'Not registered user' do
      it 'tries to update answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author answers' do
      before { login(user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }
      before { login(not_author) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(question.answers, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(question.answers, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'POST #best_answer' do
    let(:not_author_question) { create(:user) }
    let!(:question) { create(:question_factory, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer_2) { create(:answer, question: question, user: not_author_question) }

    context 'The author of the question' do
      before { login(user) }
      
      it 'can choose the best answer' do
        post :best_answer, params: {id: answer, format: :js }
        question.reload
        expect(question.best_answer).to eq answer
      end
    end
    
    context 'Not the author of the question' do
      before { login(not_author_question) }
      it 'can not choose the best answer' do
        post :best_answer, params: {id: answer, format: :js }
        question.reload
        expect(question.best_answer).to_not eq answer
      end
    end
  end
end
