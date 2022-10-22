# frozen_string_literal: true

::Rails.application.config.app_middleware.use ::Warden::Manager do |config|
  config.scope_defaults(
    :user,
    store: false,
    strategies: [:credentials]
  )

  config.scope_defaults(
    :webhook,
    store: false,
    strategies: [:github_signature]
  )

  config.failure_app = ->(env) do
    [401, {'Content-Type' => 'application/json'}, ['{"error": "Unauthorized"}']]
  end
end

Warden::Strategies.add(:credentials) do
  def valid?
    params['login'].present? && params['password'].present?
  end
 
  def authenticate!
    return success! if ::Auth::User::BasicAuth.authenticate!(params[:login], params[:password])
    fail 'Invalid Email or Password'
  end
end

Warden::Strategies.add(:github_signature) do
  def valid?
    signature.present?
  end
 
  def authenticate!
    return success! ::Auth::Webhook::Github.authenticate!(payload, signature)
    fail 'Invalid Email or Password'
  end

  private

  def payload
    @payload ||= request.body.read
  end

  def signature
    @signature ||= request.env['HTTP_X_HUB_SIGNATURE_256']
  end
end