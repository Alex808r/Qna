# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comments to question', %q{
  To clarify a question or answer
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_factory, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create comment to question', js: true do
      within '.new-question-comment' do
        fill_in 'Comment', with: 'My comment'
        click_on 'Create Comment'
      end
      expect(page).to have_content('My comment')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not create comment' do
      visit question_path(question)

      expect(page).to_not have_link 'Create Comment'
    end
  end

  context 'multiple  sessions' do
    scenario 'comment appears on another users page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-question-comment' do
          fill_in 'Comment', with: 'Session question comment'
          click_on 'Create Comment'
        end
        expect(page).to have_content('Session question comment')
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Session question comment')
      end
    end
  end
end
