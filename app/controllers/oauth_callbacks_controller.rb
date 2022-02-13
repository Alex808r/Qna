# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    set_oauth_by('Github')
  end

  def vkontakte
    set_oauth_by('VK')
  end

  private

  # rubocop:disable Naming/AccessorMethodName
  # rubocop:disable Metrics/AbcSize
  def set_oauth_by(provider)
    unless request.env['omniauth.auth'].info[:email]
      redirect_to users_set_email_path
      return
    end

    @user = FindForOauthService.new(request.env['omniauth.auth']).call

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
  # rubocop:enable Naming/AccessorMethodName
  # rubocop:enable Metrics/AbcSize
end
