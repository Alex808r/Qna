class Answer < ApplicationRecord
  belongs_to :question

  validates :title, :body, :question_id, presence: true
end
