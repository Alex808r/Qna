# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:author) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question_factory, user: author) }

  describe 'POST #create' do
    let(:subscriptions_request) { post :create, params: { question_id: question, format: :js } }

    context 'Authenticated user' do
      context 'author of question' do
        before { login(author) }

        it 'can create subscription' do
          expect { subscriptions_request }.to change(question.subscriptions, :count).by(1)
        end

        it 'assigns subscription' do
          subscriptions_request
          expect(assigns(:subscription).user).to eq author
        end
      end

      context 'not author of question' do
        before { login(not_author) }

        it 'can create subscription' do
          expect { subscriptions_request }.to change(question.subscriptions, :count).by(1)
        end

        it 'assigns subscription' do
          subscriptions_request
          expect(assigns(:subscription).user).to eq not_author
        end
      end
    end

    context 'Not authenticated user' do
      it 'can not create subscription' do
        expect { subscriptions_request }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    let!(:question) { create(:question_factory, user: author) }
    let!(:subscription) { create(:subscription, question: question, user: author) }
    let!(:not_author_subscription) { create(:subscription, question: question, user: not_author) }
    let(:destroy_subscription) { delete :destroy, params: { id: subscription, format: :js } }
    let(:not_author_destroy_subscription) { delete :destroy, params: { id: not_author_subscription, format: :js } }

    context 'Authenticated user' do
      context 'author of question' do
        before { login(author) }

        it 'can delete his subscription(association with question)' do
          expect { destroy_subscription }.to change(question.subscriptions, :count).by(-1)
        end
        it 'can delete his subscription(association with user)' do
          expect { destroy_subscription }.to change(author.subscriptions, :count).by(-1)
        end

        it 'can not delete subscriptions other users' do
          expect { not_author_destroy_subscription }.to raise_exception ActiveRecord::RecordNotFound
        end
      end

      context 'not author of question' do
        before { login(not_author) }

        it 'can delete his subscription(association with question)' do
          expect { not_author_destroy_subscription }.to change(question.subscriptions, :count).by(-1)
        end

        it 'can delete his subscription(association with user)' do
          expect { not_author_destroy_subscription }.to change(not_author.subscriptions, :count).by(-1)
        end

        it 'can not delete subscriptions other users' do
          expect { destroy_subscription }.to raise_exception ActiveRecord::RecordNotFound
        end
      end
    end

    context 'Not authenticated user' do
      it 'can not delete subscription other users' do
        expect { destroy_subscription }.to_not change(question.subscriptions, :count)
        expect { destroy_subscription }.to_not change(author.subscriptions, :count)
        expect { not_author_destroy_subscription }.to_not change(question.subscriptions, :count)
        expect { not_author_destroy_subscription }.to_not change(not_author.subscriptions, :count)
      end
    end
  end
end
