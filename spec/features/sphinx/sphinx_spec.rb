# frozen_string_literal: true

require 'sphinx_helper'

feature 'Every one user can use search', %q{
  To quickly find a question and answer
  As guest or authenticate  user
  I would like to be able to searching question and abswer by words
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question_factory, user: user) }

  before do
    visit root_path
    ThinkingSphinx::Test.index
  end

  scenario 'Search without input word', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_body, with: ''
      click_on 'Search'
      expect(page).to have_content 'No results'
    end
  end

  scenario 'Search question by title with type All', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_body, with: question.title
      select 'All', from: :type
      click_on 'Search'
      expect(page).to have_content question.title
    end
  end

  scenario 'Search question by title with type Question', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_body, with: question.title
      select 'Question', from: :type
      click_on 'Search'

      expect(page).to have_content question.title
    end
  end

  scenario 'Can not find question title by search type Comment', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_body, with: question.title
      select 'Comment', from: :type
      click_on 'Search'

      expect(page).to have_content 'No results'
    end
  end
end
