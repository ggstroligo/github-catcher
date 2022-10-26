module Api
  class EventsController < ::Api::BaseController
    before_action :authenticate_user!

    def index
      issue = ::Issue::Record.find(params[:issue_id])
      events = ::Issue::Repository.load_events_for(issue).map(&:as_json)

      render json: events, status: :ok
    end
  end
end