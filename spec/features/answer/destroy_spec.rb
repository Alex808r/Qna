# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove answer of a question
  As an answer author
  I'd like to be able to delete answer
} do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question_factory, user: user) }
  # given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_with_file) { create(:answer, :with_file, question: question, user: user) }

  describe 'Authenticated user' do
    context 'Author answer' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'delete his answer', js: true do
        expect(page).to have_content answer_with_file.body
        click_on 'Delete answer'
        # expect(page).to have_content 'Your answer successfully deleted'
        expect(page).to_not have_content(answer_with_file.body)
      end

      scenario 'delete attahce files', js: true do
        expect(page).to have_content answer_with_file.body
        within '.answers' do
          expect(page).to have_link file_name(answer_with_file)
          click_on 'Delete file'

          expect(page).to_not have_link file_name(answer_with_file)
          expect(page).to_not have_link 'Delete file'
        end
      end
    end

    context 'Not author' do
      background do
        sign_in(not_author)
        visit question_path(question)
      end

      scenario 'can not delete answer', js: true do
        expect(page).to_not have_link 'Delete answer'
      end

      scenario 'can not delete files', js: true do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not delete answer', js: true do
      expect(page).to_not have_link 'Delete answer'
    end

    scenario 'can not delete files', js: true do
      expect(page).to_not have_link 'Delete file'
    end
  end

  def file_name(item)
    item.files.first.filename.to_s
  end
end
