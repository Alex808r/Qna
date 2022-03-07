# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe on the on the new answer to question', %q{
    In order to notify email
    As an authenticated user
    I would like to be notified of a new answer to a question
} do
  given!(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question_factory, user: author) }
  given(:subscription) { create(:subscription, question: question, user: author) }

  describe 'Authenticated user' do
    context 'auhtor of question' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'have subscription by default' do
        within('.subscription') do
          expect(page).to have_link 'Not notify about new answer'
        end
      end

      scenario 'can unsubscribe', js: true do
        within('.subscription') do
          expect(page).to_not have_link 'Notify about new answer'
          expect(page).to have_link 'Not notify about new answer'

          click_link 'Not notify about new answer'

          expect(page).to_not have_link 'Not notify about new answer'
          expect(page).to have_link 'Notify about new answer'
        end
      end
    end

    context 'not author of question', js: true do
      scenario 'can subscribe' do
        sign_in(not_author)
        visit question_path(question)

        within('.subscription') do
          expect(page).to_not have_content 'Not notify about new answer'
          expect(page).to have_content 'Notify about new answer'

          click_link 'Notify about new answer'

          expect(page).to have_content 'Not notify about new answer'
          expect(page).to_not have_content 'Notify about new answer'
        end
      end

      scenario 'can unsubscribe' do
        sign_in(not_author)
        visit question_path(question)
        click_link 'Notify about new answer'

        within('.subscription') do
          expect(page).to have_content 'Not notify about new answer'
          expect(page).to_not have_content 'Notify about new answer'

          click_link 'Not notify about new answer'

          expect(page).to_not have_content 'Not notify about new answer'
          expect(page).to have_content 'Notify about new answer'
        end
      end
    end
  end

  describe 'Not authenticate user', js: true do
    scenario 'can not see link subscribe or unsubscribe' do
      visit question_path(question)
      expect(page).to_not have_content 'Not notify about new answer'
      expect(page).to_not have_content 'Notify about new answer'
    end
  end
end
