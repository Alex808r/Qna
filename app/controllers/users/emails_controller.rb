# frozen_string_literal: true

class Users::EmailsController < ApplicationController
  def new; end

  def create
    user = User.where(email: email).first
    if user
      sign_in_and_redirect user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email, password: password, password_confirmation: password)
      if user.persisted?
        user.send_confirmation_instructions
        # sign_in_and_redirect user
      else
        render :new
      end
    end
  end

  private

  def email
    params.require(:email)
  end
end
