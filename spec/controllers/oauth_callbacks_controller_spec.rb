# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Github' do
    # let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }

    let(:oauth) { mock_auth_hash(:github, 'user@example.com') }
    before { @request.env['omniauth.auth'] = mock_auth_hash(:github, 'user@example.com') }

    # it 'finds user from oauth data' do
    #   allow(request.env).to receive(:[]).and_call_original
    #   allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    #   expect(User).to receive(:find_for_oauth).with(oauth_data)
    #   get :github
    # end

    context 'user exists' do
      # let!(:user) { create(:user) }

      let(:user) { FindForOauthService.new(oauth).call }

      before do
        # allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        # allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      # it 'does not login user' do
      #   expect(subject.current_user).to_not be
      # end
    end

    context 'has no user email' do
      before { @request.env['omniauth.auth'] = mock_auth_hash(:github, email: nil) }

      it 'redirects to submit email form' do
        get :github
        expect(response).to redirect_to users_set_email_path
      end
    end

    describe 'Vkontakte' do
      let(:oauth) { mock_auth_hash(:vkontakte, 'user@example.com') }
      before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte, 'user@example.com') }

      context 'user exist' do
        let(:user) { FindForOauthService.new(oauth).call }

        before { get :vkontakte }

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before { get :vkontakte }

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'has no user email' do
        before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte, email: nil) }

        it 'redirects to submit email form' do
          get :vkontakte
          expect(response).to redirect_to users_set_email_path
        end
      end
    end
  end
end
