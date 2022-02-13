# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_hash(provider, email = nil)
    email = email[0] if email.instance_of?(Hash)

    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: '123456',
      info: {
        email: email
      }
    )
  end
end
