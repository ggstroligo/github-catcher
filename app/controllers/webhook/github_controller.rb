module Webhook
  class GithubController < BaseController
    before_action :authenticate_user!

    def create; end
  end
end