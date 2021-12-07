# frozen_string_literal: true

require 'rails_helper'

feature 'User can view current question', %q{
  In order to get answer from a community
  as user
  I'd like to be able to views current question and the answers to it
} do
  
  given(:user){ create(:user) }
  given(:question) { create(:question_factory) }
  given!(:answers) { create_list(:answer, 3, question: question)}

  background { visit question_path(question) }
  
  scenario 'User can view cuttent question ' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User can view question answers'  do
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end