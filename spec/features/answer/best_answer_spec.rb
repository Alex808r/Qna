# frozen_string_literal: true

require 'rails_helper'

feature 'The user can choose the best answer to the question', %q{
  To display the best answer to the question above the other answers
  As the author of the question
  I would like to choose the best answer to a question
} do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question_factory, user: user) }
  given(:question_with_reward) { create(:question_factory, :with_reward, user: user) }
  given!(:answer) { create(:answer, question: question, user: not_author) }
  given(:rewarded_answer) { create(:answer, question: question_with_reward, user: not_author) }

  describe 'Unauthenticated user' do
    scenario 'can not choose the best answer', js: true do
      visit questions_path(question)
      expect(page).to_not have_link 'Best answer'
    end
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

      scenario 'give an reward for the best answer' do
        sign_in(user)
        visit question_path(rewarded_answer.question)

        click_on 'Best answer'

        question_with_reward.reload
        # save_and_open_page_wsl
        # sleep 1
        expect(page).to have_content(question_with_reward.title)
        expect(question_with_reward.reward.user).to eq not_author
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
