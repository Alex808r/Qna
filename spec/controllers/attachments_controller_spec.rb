# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, :with_file, user: user) }
  let!(:answer) { create(:answer, :with_file, question: question, user: user) }

  describe 'DELETE #destroy' do
    context 'Author answers' do
      before { login(user) }

      it 'delete the attached file' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
          .to change(answer.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author question' do
      before { login(user) }

      it 'delete the attached file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to change(question.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author answer' do
      let(:not_author) { create :user }

      it 'tries to delete file' do
        login(not_author)
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
          .to_not change(answer.files, :count)
      end
    end

    context 'Not author question' do
      let(:not_author) { create :user }

      it 'tries to delete file' do
        login(not_author)
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to_not change(question.files, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
          .to_not change(answer.files, :count)
      end

      it 'tries to delete question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to_not change(question.files, :count)
      end
    end
  end
end
