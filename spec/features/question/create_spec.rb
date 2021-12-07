# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }
  
  scenario 'Authenticated user asks a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    click_on 'Ask'
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test question body'
  end
  
  scenario 'Authenticated user asks a question with errors' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    click_on 'Ask'
    expect(page).to have_content "Title can't be blank"
  end
  
  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
  
end
