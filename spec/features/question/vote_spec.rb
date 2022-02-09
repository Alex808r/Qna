# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question', %q{
  To raise the rating of a question
  As an authenticated user(not author question)
  I would like to be able to vote
} do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question_factory, user: author) }

  describe 'Authenticated user', js: true do
    context 'not author of question', js: true do
      background do
        sign_in(not_author)
        visit question_path(question)
      end

      scenario 'can votes up for question', js: true do
        within "#question-list-item-#{question.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Up'

          within '.rating' do
            expect(page).to have_content 'Rating: 1'
            expect(page).to_not have_content 'Rating: 0'
          end
        end
      end

      scenario 'can not votes up twice' do
        within "#question-list-item-#{question.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Up'
          click_on 'Up'

          within '.rating' do
            expect(page).to have_content 'Rating: 1'
            expect(page).to_not have_content 'Rating: 2'
          end
        end
      end

      scenario 'cancel vote' do
        within "#question-list-item-#{question.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Up'
          click_on 'Cancel'

          within '.rating' do
            expect(page).to have_content 'Rating: 0'
            expect(page).to_not have_content 'Rating: 1'
          end
        end
      end

      scenario 'can votes down for question' do
        within "#question-list-item-#{question.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Down'

          within '.rating' do
            expect(page).to have_content 'Rating: -1'
            expect(page).to_not have_content 'Rating: 0'
          end
        end
      end

      scenario 'can not to vote down twice' do
        within "#question-list-item-#{question.id}" do
          expect(page).to have_content 'Rating: 0'

          click_on 'Down'
          click_on 'Down'

          within '.rating' do
            expect(page).to have_content 'Rating: -1'
            expect(page).to_not have_content 'Rating: -2'
          end
        end
      end

      scenario 'can change vote' do
        within "#question-list-item-#{question.id}" do
          click_on 'Up'
          click_on 'Cancel'
          click_on 'Down'

          within '.rating' do
            expect(page).to have_content 'Rating: -1'
            expect(page).to_not have_content 'Rating: 1'
            expect(page).to_not have_content 'Rating: 0 '
          end
        end
      end

      scenario 'can not change vote with button Down' do
        within "#question-list-item-#{question.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Up'
          click_on 'Down'

          within '.rating' do
            expect(page).to have_content 'Rating: 1'
            expect(page).to_not have_content 'Rating: 0'
          end
        end
      end
    end

    context 'Author of question', js: true do
      background do
        sign_in author
        visit question_path(question)
      end

      scenario 'can not vote for his question' do
        expect(page).to_not have_selector '.vote-actions'
      end
    end
  end

  describe 'Unauthorized user' do
    background { visit question_path(question) }

    scenario 'can not vote for some question' do
      expect(page).to_not have_selector '.vote-actions'
    end
  end
end
