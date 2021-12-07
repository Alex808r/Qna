# frozen_string_literal: true

require 'rails_helper'

feature 'The user can create an answer to the question ', %q{
  To help the community
  As an authenticated user
  I would like to create an answer to the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_factory) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'created an answer to the question' do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer body'
      click_on 'Create Answer'
      
      expect(page).to have_content 'Answer successfully created'
      expect(page).to have_content 'Answer title'
      expect(page).to have_content 'Answer body'
    end
    
    scenario 'tried to create an answer to the question with errors' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't create answer" do
    visit question_path(question)

    #expect(page).to_not have_content 'Create Answer'
    expect(page).to_not have_link 'Create answer'
  end
  
end