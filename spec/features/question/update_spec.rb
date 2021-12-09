# frozen_string_literal: true

require 'rails_helper'

feature 'User can update question', %q{
  To fix the error
  As an authenticated user
  I would like to change my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question_factory, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      # save_and_open_page_wsl
      click_link 'edit'
    end

    scenario ' uptade the question' do
      fill_in 'Title', with: 'Update title'
      fill_in 'Body', with: 'Update body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully updated.'
      expect(page).to have_content 'Update title'
      expect(page).to have_content 'Update body'
    end

    scenario ' udpate a question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario ' tries to update a question' do
      visit questions_path
      click_on 'edit'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'Not author' do
    given(:not_author) { create(:user) }
    background { sign_in(not_author) }

    scenario ' tries to update a question' do
      visit questions_path
      click_on 'edit'
      fill_in 'Title', with: 'Update title'
      fill_in 'Body', with: 'Update body'
      click_on 'Ask'

      expect(page).to have_content 'Cannot update. You are not the author of the question.'
    end
  end
end
