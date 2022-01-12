# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question_factory, user: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:thinknetica_url) { 'https://thinknetica.com/' }
  given(:invalid_url) { 'Invalid_url' }

  describe 'User adds link when give an answer' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer body'
    end

    scenario 'with valid url', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add one more link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'Thinknetica'
        fill_in 'Url', with: thinknetica_url
      end

      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Thinknetica', href: thinknetica_url
      end
    end

    scenario 'with valid url', js: true do
      fill_in 'Link name', with: 'Invalid'
      fill_in 'Url', with: invalid_url

      click_on 'Create Answer'

      expect(page).to_not have_link 'Invalid', href: gist_url
      expect(page).to have_content 'is invalid'
      expect(page).to_not have_content 'Answer title'
    end
  end
end
