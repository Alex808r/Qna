# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, user: user) }
  let!(:answer) { create(:answer, :with_file, question: question, user: user) }

  describe 'DELETE #destroy' do
    context 'Author answers' do
      before { login(user) }

      it 'delete the attached file' do
        expect { delete :destroy, params: { id: answer.answer_files.first }, format: :js }
          .to change(answer.answer_files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer.answer_files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }

      it 'tries to delete file' do
        login(not_author)
        expect { delete :destroy, params: { id: answer.answer_files.first }, format: :js }
          .to_not change(answer.answer_files, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete ' do
        expect { delete :destroy, params: { id: answer.answer_files.first }, format: :js }
          .to_not change(answer.answer_files, :count)
      end
    end
  end
end
