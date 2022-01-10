# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question_factory, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } } # эквивалент get :show, params: {id: question.id}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns the new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the @best_answer' do
      expect(assigns(:best_answer)).to eq question.best_answer
    end
  end

  describe 'GET #new' do
    # before {sign_in(user)}
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'change the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question_factory) } }
          .to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question_factory) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question_factory, :invalid) } }
          .not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question_factory, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:question) { create(:question_factory, user: user) }

    context 'Author question' do
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question_factory) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render template update' do
          patch :update, params: { id: question, question: attributes_for(:question_factory) }, format: :js
          expect(response).to render_template :update
        end
      end
      context 'with invalid attributes' do
        it 'does not change question' do
          patch :update, params: { id: question, question: attributes_for(:question_factory, :invalid) }, format: :js
          question.reload
          expect(question.body).to eq 'MyText'
        end

        it 're-renders template update' do
          patch :update, params: { id: question, question: attributes_for(:question_factory, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Not Author questions' do
      let(:not_author) { create(:user) }
      before { login(not_author) }

      it 'only author update attibute question' do
        patch :update, params: { id: question, question: { title: 'not new title', body: 'not new body' } }, format: :js
        question.reload
        expect(question.title).to_not eq 'not new title'
        expect(question.body).to_not eq 'not new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question_factory, user: user) }

    context 'Author questions' do
      before { login(user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author' do
      let(:not_author) { create(:user) }
      before { login(not_author) }

      it 'cannot delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to @question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'Not registered user' do
      it 'cannot delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
