# frozen_string_literal: true

require 'rails_helper'

feature 'User can view his rewards', %q{
  To see the number of rewards
  as a user
  I would like to be able to view a list of my awards
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_factory, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:reward) { create(:reward, question: question) }

  describe 'Authenticated user' do
    scenario 'can see his rewards', js: true do
      sign_in(user)
      visit question_path(answer.question)

      click_on 'Best answer'
      click_on 'My Rewards'
      # visit show_rewards_user_path(user)
      expect(page).to have_content reward.name
    end

    scenario 'without rewards' do
      sign_in(user)
      visit root_path

      click_on 'My Rewards'
      expect(page).to_not have_content reward.name
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to see a rewards' do
      visit root_path
      expect(page).to_not have_link reward.name
    end
  end
end
