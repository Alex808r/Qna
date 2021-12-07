# frozen_string_literal: true

require 'rails_helper'

feature 'User can view questions', %q{
  In order to get answer from a community
  as user
  I'd like to be able to views all questions
} do
  given!(:questions) { create_list(:question_factory, 3) }
  
  scenario 'view all questions' do
    visit questions_path
    expect(page).to have_content 'All Questions'
    expect(questions.size).to eq Question.count
    questions.each { |question| expect(page).to have_content question.title }
  end

end