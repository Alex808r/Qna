# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_factory, :with_link, user: user) }
  let(:answer) { create(:answer, :with_link, question: question, user: user) }

  describe 'DELETE #destroy' do
    context 'Author question' do
      before { login(user) }

      it 'delete the link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }
          .to change(question.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author answer' do
      before { login(user) }

      it 'delete the link' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }
          .to change(answer.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author question' do
      let(:not_author) { create :user }

      it 'tries to delete link' do
        login(not_author)

        expect { delete :destroy, params: { id: question.links.first }, format: :js }
          .to_not change(question.links, :count)
      end
    end

    context 'Not author answer' do
      let(:not_author) { create :user }

      it 'tries to delete link' do
        login(not_author)

        expect { delete :destroy, params: { id: answer.links.first }, format: :js }
          .to_not change(answer.links, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }
          .to_not change(question.links, :count)
      end

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }
          .to_not change(answer.links, :count)
      end
    end
  end
end
