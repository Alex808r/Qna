# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', %q{
  In order to remove question
  As an question author
  I'd like to be able to delete question
} do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  # given!(:question) { create(:question_factory, user: user) }
  given(:question_with_file) { create(:question_factory, :with_file, user: user) }
  given(:question_with_link) { create(:question_factory, :with_link, user: user) }

  describe 'Authenticated user' do
    context 'Author question' do
      background do
        sign_in(user)
        visit question_path(question_with_file)
      end

      scenario 'delete his question' do
        expect(page).to have_content question_with_file.title
        click_on 'Delete Question'

        expect(page).to have_content 'Your question successfully deleted'
        expect(page).to_not have_content question_with_file.title
      end

      scenario 'delete attahce files', js: true do
        within '.question' do
          expect(page).to have_link file_name(question_with_file)
          click_on 'Delete file'

          expect(page).to_not have_link file_name(question_with_file)
          expect(page).to_not have_link 'Delete file'
        end
      end

      scenario 'delete link', js: true do
        visit question_path(question_with_link)

        expect(page).to have_link question_with_link.links.first.name

        within "#link_#{link_id(question_with_link)}" do
          expect(page).to have_link 'MyString', href: 'https://thinknetica.com'
          click_on 'Delete link'
        end
        expect(page).not_to have_link 'MyString'
        expect(page).not_to have_link 'Delete link'
      end
    end

    context 'Not Author question' do
      background do
        sign_in(not_author)
        visit question_path(question_with_file)
      end

      scenario 'can not delete question' do
        expect(page).to_not have_link 'Delete question'
      end

      scenario 'can not delete attahce files', js: true do
        within '.question' do
          expect(page).to_not have_link 'Delete file'
        end
      end

      scenario 'can not delete link', js: true do
        visit question_path(question_with_link)

        within "#link_#{link_id(question_with_link)}" do
          expect(page).to_not have_link 'Delete link'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question_with_file) }

    scenario 'can not delete question' do
      expect(page).to_not have_link 'Delete question'
    end

    scenario 'can not delete attahce files', js: true do
      within '.question' do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'can not delete link' do
      visit question_path(question_with_link)

      within "#link_#{link_id(question_with_link)}" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  def file_name(item)
    item.files.first.filename.to_s
  end

  def link_id(item)
    item.links.first.id
  end
end
