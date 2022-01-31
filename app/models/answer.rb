# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, :question_id, presence: true
end
