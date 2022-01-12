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

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)
    # save_and_open_page_wsl

    fill_in 'Title', with: 'Answer title'
    fill_in 'Body', with: 'Answer body'

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
end
