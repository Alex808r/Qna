# frozen_string_literal: true

require 'rails_helper'

feature 'Sidekiq web panel' do
  given(:admin) { create(:user, :admin) }
  given(:not_admin) { create(:user) }

  describe 'Authenticated user' do
    context 'with admin status' do
      scenario 'can see sidekiq web panel ' do
        sign_in(admin)
        visit sidekiq_web_path
        expect(page).to have_content(/Sidekiq/)
        expect(page).to have_current_path(sidekiq_web_path)
      end
    end

    context 'without admin status' do
      scenario 'can not see sidekiq web panel' do
        sign_in(not_admin)
        expect { visit sidekiq_web_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'Not authenticated user' do
    scenario 'can not see sidekiq web panel' do
      visit sidekiq_web_path
      expect(page).to_not have_content(/Sidekiq/)
      expect(current_path).to eq('/users/sign_in')
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
