# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  # rubocop:disable Metrics/AbcSize

  def user_abilities
    guest_abilities
    can %i[create create_comment], [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :best_answer, Answer, question: { user: user }

    can %i[vote_up vote_down vote_cancel], [Question, Answer] do |votable_object|
      votable_object.user != user
    end

    can :destroy, [Question, Answer], user: user
    can :destroy, Link, linkable: { user: user }
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
  end

  # rubocop:enable Metrics/AbcSize
end
