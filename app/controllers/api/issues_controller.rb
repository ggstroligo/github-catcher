module Api
  class IssuesController < ::Api::BaseController
    before_action :authenticate_user!

    def index
    end
  end
end