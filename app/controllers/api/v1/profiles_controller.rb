# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end

  # def all_users
  #   @users = User.where.not(id: current_resource_owner.id)
  #   render json: @users
  # end
end
