# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign in
} do
  
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    # save_and_open_page_wsl
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@email.com'
    fill_in 'Password', with: '00000000'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end
end
