# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:thinknetica_url) { 'https://thinknetica.com/' }
  given(:invalid_url) { 'Invalid_url' }

  describe 'User adds link when asks question' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'with valid url', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add one more link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'Thinknetica'
        fill_in 'Url', with: thinknetica_url
      end

      click_on 'Ask'

      within '.question' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Thinknetica', href: thinknetica_url
      end
    end

    scenario 'with invalid url', js: true do
      fill_in 'Link name', with: 'Invalid'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to_not have_link 'Invalid', href: invalid_url
      expect(page).to have_content 'is invalid'
      expect(page).to_not have_content 'Test question'
    end
  end
end
