# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be adle to edit my answer
}do
  
  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question_factory) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  scenario "Unauthenticated user can't edit answer" do
    visit questions_path(question)
    expect(page).to_not have_link 'Edit answer'
  end


  describe 'Authenticated user' do
    context 'Author answer' do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit answer'
      end
      scenario 'edit his answer', js: true do
        within '.answers' do #чтобы убедиться, что ответ в списке, а не в форме
          fill_in 'Title', with: 'edited title'
          fill_in 'Body', with: 'edited body'
          click_on 'Save'
          
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          expect(page).to_not have_selector 'textarea'
        end
      end
      scenario 'edit answer with errors', js: true do
        within '.answers' do #чтобы убедиться, что ответ в списке, а не в форме
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content(answer.body)
          expect(page).to have_selector 'textarea'
        end

        within '.answer-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
    
    context 'Not author answer' do
      scenario 'tries to edit other users answer' do
        sign_in(not_author)
        expect(page).to_not have_link 'Edit answer'
      end
    end
  
  end
  
    #scenario "Unauthenticated user can't edit answer"
    #scenario "Authenticated user can edit answer"
    #scenario "Validates mistakes"
    #scenario 'Authenticated user tries to edit not your answer'

end