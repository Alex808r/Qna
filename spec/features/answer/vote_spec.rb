# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for answer', %q{
  To raise the rating of a answer
  As an authenticated user(not author answer)
  I would like to be able to vote
} do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question_factory, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user', js: true do
    context 'not author of answer', js: true do
      background do
        sign_in(not_author)
        visit question_path(question)
      end

      scenario 'can votes up for answer', js: true do
        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Up'

          within '.rating' do
            expect(page).to have_content 'Rating: 1'
            expect(page).to_not have_content 'Rating: 0'
          end
        end
      end

      scenario 'can not votes up twice' do
        within "#answer-#{answer.id}" do
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
        within "#answer-#{answer.id}" do
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
        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Down'

          within '.rating' do
            expect(page).to have_content 'Rating: -1'
            expect(page).to_not have_content 'Rating: 0'
          end
        end
      end

      scenario 'can not to vote down twice' do
        within "#answer-#{answer.id}" do
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
        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Up'
          click_on 'Cancel'
          click_on 'Down'

          within '.rating' do
            expect(page).to have_content 'Rating: -1'
            expect(page).to_not have_content 'Rating: 1'
            expect(page).to_not have_content 'Rating: 0'
          end
        end
      end

      scenario 'can not change vote with button Down' do
        within "#answer-#{answer.id}" do
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

    context 'Author of answer', js: true do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'can not vote for his answer' do
        expect(page).to_not have_selector '.vote-actions'
      end
    end
  end

  describe 'Unauthorized user' do
    background { visit question_path(question) }

    scenario 'can not vote for some answer' do
      expect(page).to_not have_selector '.vote-actions'
    end
  end
end
