# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :title, :body, :question_id, presence: true
end
