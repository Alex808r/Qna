# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  # rubocop:disable Naming/AccessorMethodName
  def set_best_answer(answer)
    transaction do
      update(best_answer: answer)
      reward&.update(user: answer.user)
    end
  end
  # rubocop:enable Naming/AccessorMethodName

  private

  after_create :calculate_reputation

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
