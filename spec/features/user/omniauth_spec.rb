# frozen_string_literal: true

require 'rails_helper'

feature 'Authorization from different providers', %q{
  To log in to the app
  As a user
  I want to be able to login with an account from different apps
} do
  given!(:user) { create(:user, email: 'user@example.com') }
  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    scenario 'user successfully signed in' do
      mock_auth_hash(:github, 'user@example.com')
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'provider do not have user email' do
      mock_auth_hash(:github)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'new@mail.ru'
      click_on 'Submit'

      open_email('new@mail.ru')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'user input invalid email' do
      mock_auth_hash(:github)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'Email', with: 'invalid_email'
      click_button 'Submit'

      expect(page).to have_selector("input[type=email][id='email']")
      expect(page).to have_selector("input[type=submit][value='Submit']")
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario 'user successfully signed in' do
      mock_auth_hash(:vkontakte, 'user@example.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from VK account.'
    end

    scenario 'provider do not have user email' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'new@mail.ru'
      click_on 'Submit'

      open_email('new@mail.ru')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'user input invalid email' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'Email', with: 'invalid_email'
      click_button 'Submit'

      expect(page).to have_selector("input[type=email][id='email']")
      expect(page).to have_selector("input[type=submit][value='Submit']")
    end
  end
end
