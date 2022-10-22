module Api
  class BaseController < ::ApplicationController
    private
    def warden
      request.env['warden']
    end

    def authenticate_user!
      warden.authenticate!(:credentials)
    end
  end
end