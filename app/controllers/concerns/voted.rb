# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable_object, only: %i[vote_up vote_down vote_cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render_response
  end

  def vote_down
    @votable.vote_down(current_user)
    render_response
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render_response
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable_object
    @votable = model_klass.find(params[:id])
  end

  def render_response
    render json: { resource_name: @votable.class.name.underscore,
                   resource_id: @votable.id,
                   rating: @votable.rating }
  end
end
