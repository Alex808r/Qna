# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show_rewards
    @rewards = current_user.rewards
  end
end
