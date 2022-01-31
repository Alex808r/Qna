# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    votes.create!(user: user, value: 1) unless vote_author?(user)
  end

  def vote_down(user)
    votes.create!(user: user, value: -1) unless vote_author?(user)
  end

  def vote_cancel(user)
    vote = Vote.where(user_id: user.id)
    votes&.destroy(vote) if vote_author?(user)
  end

  def rating
    votes.sum(:value)
  end

  def vote_author?(user)
    votes.exists?(user: user)
  end
end
