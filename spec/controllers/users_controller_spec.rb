# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question_factory, user: user) }
  let(:rewards) { create_list(:reward, 3, question: question, user: user) }

  describe 'GET #show_rewards' do
    context 'Authenticated user' do
      it 'assigns the requested reward to @rewards' do
        login(user)

        get :show_rewards, params: { id: user }
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'render template show rewards' do
        login(user)

        get :show_rewards, params: { id: user }
        expect(response).to render_template :show_rewards
      end

      it 'without rewards' do
        login(user_2)

        get :show_rewards, params: { id: user_2 }
        expect(assigns(:rewards)).to_not match_array(rewards)
      end
    end

    context 'Not authenticated user' do
      it 'can not see rewards' do
        get :show_rewards, params: { id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
