# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :answer_files

  validates :title, :body, :question_id, presence: true
end
