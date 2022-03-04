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
    can :index, User
    # can :all_users, User
  end

  def admin_abilities
    can :manage, :all
  end

  # rubocop:disable Metrics/AbcSize

  def user_abilities
    guest_abilities
    can %i[create create_comment], [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :best_answer, Answer, question: { user_id: user.id }
    can :me, User, user_id: user.id

    can %i[vote_up vote_down vote_cancel], [Question, Answer] do |votable_object|
      !user.author?(votable_object)
    end

    can :destroy, [Question, Answer], user_id: user.id
    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
  end

  # rubocop:enable Metrics/AbcSize
end
