module Webhook
  class BaseController < ::ApplicationController
    private
    def warden
      request.env['warden']
    end

    def authenticate_user!
      warden.authenticate!(:github_signature)
    end
  end
end