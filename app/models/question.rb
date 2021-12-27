# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  validates :title, :body, presence: true

  def set_best_answer(answer)
    update(best_answer: answer)
  end
end
