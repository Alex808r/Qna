# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be adle to edit my question
} do
  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question_factory, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'can not edit question to current question page(template show)' do
      visit questions_path(question)
      expect(page).to_not have_link 'Edit Question'
    end
  end

  describe 'Authenticated user', js: true do
    context 'Author question' do
      background do
        sign_in(user)
        visit question_path(question)
        # save_and_open_page_wsl
        click_on 'Edit Question'
      end
      scenario 'edit his question' do
        within '.question' do # чтобы убедиться, что впорос в списке, а не в форме
          fill_in 'Title', with: 'edited title'
          fill_in 'Body',  with: 'edited body'
          click_on 'Save update question'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          expect(page).to_not have_selector 'textarea'
        end
      end
      scenario 'edit question with errors' do
        within '.question' do # чтобы убедиться, что ответ в списке, а не в форме
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save update question'

          expect(page).to have_content(question.body)
          expect(page).to have_selector 'textarea'
        end

        within '.question-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'edit his question with attach files' do
        within '.question' do # чтобы убедиться, что впорос в списке, а не в форме
          fill_in 'Title', with: 'edited title'
          fill_in 'Body',  with: 'edited body'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save update question'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          expect(page).to_not have_selector 'textarea'
          expect(page).to have_link question.files.first.filename.to_s
          expect(page).to have_link question.files.second.filename.to_s
        end
      end
    end

    context 'Not author' do
      scenario 'tries to edit other users question' do
        sign_in(not_author)
        expect(page).to_not have_link 'Edit Question'
      end
    end
  end
end
