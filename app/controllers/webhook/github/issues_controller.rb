module Webhook
  module Github
    class IssuesController < ::Webhook::BaseController
      # before_action :authenticate_user!

      # POST /webhook/github/issues
      def create

        # This must be redefined in adverse of ActionController `params` default method
        # because ActionController overrides `action` parameter given by
        # the webhook (opened, created, closed, edited)
        # with the controller current action (index, new, show, create, update).
        params = JSON.parse(request.body.read)

        issue = build_issue_params(params)
        event = build_event_params(params)

        ::Issue::Event::Create.(issue:, event:)
          .on_success { |result| render result[:issue].as_json, status: :created }
          .on_failure(:invalid_params) { render status: :unprocessable_entity}
          .on_failure { |result| render result[:message], status: :internal_server_error}
      end

      private

      def build_issue_params(params)
        return {} unless issue_event?(params)

        issue = params["issue"]
        { number: issue["number"], title: issue["title"] }
      end

      def build_event_params(params)
        return {} unless issue_event?(params)

        { action: params["action"] }
      end

      def issue_event?(params)
        params["issue"].present?
      end
    end
  end
end
