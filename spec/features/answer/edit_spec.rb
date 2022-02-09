# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be adle to edit my answer
} do
  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question_factory) }
  # given(:answer) { create(:answer, question: question, user: user) }
  given(:answer_with_link) { create(:answer, :with_link, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'can not edit answer' do
      visit questions_path(question)
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Authenticated user' do
    context 'Author answer' do
      background do
        sign_in(user)
        visit question_path(answer_with_link.question)
        click_on 'Edit answer'
      end
      scenario 'edit his answer', js: true do
        within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
          fill_in 'Title', with: 'edited title'
          fill_in 'Body', with: 'edited body'
          click_on 'Save'

          expect(page).to_not have_content answer_with_link.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          # expect(page).to_not have_selector 'textarea'
        end
      end
      scenario 'edit answer with errors', js: true do
        within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content(answer_with_link.body)
          expect(page).to have_selector 'textarea'
        end

        within '.answer-errors' do
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'edit his answer with attahce files', js: true do
        within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
          fill_in 'Title', with: 'edited title'
          fill_in 'Body', with: 'edited body'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to_not have_content answer_with_link.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          # expect(page).to_not have_selector 'textarea'
          expect(page).to have_link answer_with_link.files.first.filename.to_s
          expect(page).to have_link answer_with_link.files.second.filename.to_s
        end
      end

      scenario 'edit his answer with link', js: true do
        within '.answers' do
          expect(page).to have_link 'MyString', href: 'https://thinknetica.com'
          fill_in 'Link name', with: 'New link'
          fill_in 'Url', with: 'http://ya.ru'
          click_on 'Save'
        end
        expect(page).not_to have_link 'MyString', href: 'https://thinknetica.com'
        expect(page).to have_link 'New link', href: 'http://ya.ru'
      end
    end

    context 'Not author answer' do
      background do
        sign_in(not_author)
        visit question_path(answer_with_link.question)
      end

      scenario 'tries to edit other users answer' do
        within '.answers' do
          expect(page).not_to have_link 'Edit answer'
        end
      end
    end
  end
end
