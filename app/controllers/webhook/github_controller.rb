module Webhook
  class GithubController < ::Webhook::BaseController
    before_action :authenticate_user!

    def create
      binding.irb
      issue = 1
    end

    private

    # ActionController overrides `action` parameter given by the api (opened, created, closed, edited) 
    # with the controller actual action.
    def params
      @params ||= JSON.parse(request.body.read)
    end
  end
end