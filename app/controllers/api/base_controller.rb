module Api
  class BaseController < ::ApplicationController
    # rescue_from ::ActiveRecord::RecordNotFound, with: :not_found

    private
    def warden
      request.env['warden']
    end

    def authenticate_user!
      warden.authenticate!(:credentials)
    end
  end
end