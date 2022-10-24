module Issue
  module Event
    class Create < BaseService
      def initialize(issue:, event:)
        @issue = issue.deep_symbolize_keys
        @event = event.deep_symbolize_keys
      end

      steps :validate_params,
            :build_params,
            :insert_issue_and_event

      private
      attr_reader :issue, :event

      def validate_params
        invalid_params = {}
        invalid_params[:issue] = issue unless valid_issue?(issue)
        invalid_params[:event] = event unless valid_event?(event)
        return failure!(:invalid_params, invalid_params:) if invalid_params.present?

        action = event[:action]
        permitted = ::Issue::Event::ACTIONS
        return failure!(:unpermitted_action, action:, permitted:) unless valid_action?(action)

        success!(:valid_params, issue:, event:)
      end

      def build_params
        issue = ::Issue::Entity.new(result[:issue])
        event = ::Issue::Event::Entity.new(result[:event])

        success!(issue:, event:)
      end

      def insert_issue_and_event
        issue, event = 
        ActiveRecord::Base.transaction do
          issue = ::Issue::Repository.insert_or_update(result[:issue])
          event = ::Issue::Repository.add_event_for(issue, result[:event])

          [issue, event]
        end

        success!(:created, issue:, event:)
      end

      def valid_issue?(issue)
        return false unless issue.is_a? Hash
        return false unless issue.values_at(:title, :number).all?(&:present?)

        true
      end

      def valid_event?(event)
        return false unless event.is_a? Hash
        return false unless event.values_at(:action).all?(&:present?)

        true
      end

      def valid_action?(action)
        return false unless ACTIONS.include?(action.to_s)

        true
      end
    end
  end
end