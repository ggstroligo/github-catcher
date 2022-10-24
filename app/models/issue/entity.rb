module Issue
  class Entity < BaseStruct
    attribute :id, Type::Integer.optional.default(nil)
    attribute :title, Type::Strict::String
    attribute :number, Type::Coercible::String
    with_timestamps

    def persisted? = id.present?

    def self.from_record(record)
      new(
        id:         record.id,
        number:     record.number,
        title:      record.title,
        created_at: record.created_at,
        updated_at: record.updated_at,
      )
    end

    def to_record
      Issue::Record.new(id:, number:, title:)
    end
  end
end
