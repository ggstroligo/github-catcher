module Issue
  module Event
    class Entity < BaseStruct
      # All possible `actions` for an `issue`, based on documentation:
      # https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#webhook-payload-object-19
      EventType = Type::Coercible::String.enum(*ACTIONS)

      attribute :id, Type::Integer.optional.default(nil)
      attribute :action, EventType
      attribute :issue_id, Type::Integer.optional.default(nil)

      with_timestamps()

      def persisted? = id.present? && issue_id.present?

      def self.from_record(record)
        new(
          id:         record.id,
          action:     record.action,
          issue_id:   record.actionable_id,
          created_at: record.created_at,
          updated_at: record.updated_at
        )
      end
    end
  end
end
