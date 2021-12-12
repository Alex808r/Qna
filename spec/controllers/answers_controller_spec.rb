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
        # expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }
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

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    
    context 'Author update answer' do
    before { login(user) }
      context 'with valid attributes' do
        # it 'assigns the requested answer to @answer' do
        #   patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        #   expect(assigns(:answer)).to eq answer
        # end
  
        it 'changes answer attributes' do
          patch :update,
                params: { question_id: question, id: answer, answer: { title: 'new answer', body: 'new answer' } }, format: :js
          answer.reload
          expect(answer.title).to eq 'new answer'
          expect(answer.body).to eq 'new answer'
        end
  
        it 'renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end
  
      context 'with invalid attributes' do
        it 'does not change answer' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } , format: :js
          answer.reload
          expect(answer.title).to eq 'MyAnswer'
        end
  
        it 're-renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
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

  describe '#destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author answers' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }
      before { login(not_author) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not registered user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
