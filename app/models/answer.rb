# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :title, :body, :question_id, presence: true

  after_commit :send_notification, on: :create

  def send_notification
    NotifyAboutNewAnswerJob.perform_later(self)
  end
end
