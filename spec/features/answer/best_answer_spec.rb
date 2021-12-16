# frozen_string_literal: true

require 'rails_helper'

feature 'The user can choose the best answer to the question', %q{
  To display the best answer to the question above the other answers
  As the author of the question
  I would like to choose the best answer to a question
} do
  given!(:user) { create(:user) }
  given!(:not_author) { create(:user) }
  given!(:question) { create(:question_factory, user: user) }
  given!(:answer) { create(:answer, question: question, user: not_author) }

  scenario "Unauthenticated user can't choose the best answer", js: true do
    visit questions_path(question)
    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user', js: true do
    context 'Author of the question' do
      scenario 'can choose the best answer' do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          expect(page).to have_link 'Best answer'
          click_on 'Best answer'
          expect(page).to have_content 'The best answer'
          expect(page).to have_content answer.title
        end
      end
    end

    context 'Not author the question' do
      scenario 'can not choose the best answer' do
        sign_in(not_author)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_link 'Best answer'
        end
      end
    end
  end
end
