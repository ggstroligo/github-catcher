module Issue::Repository
  module_function

  def insert_or_update(issue)
    record = Issue::Record.find_or_initialize_by(number: issue[:number]).tap do |record|
      record.title = issue[:title]
    end

    record.save!

    ::Issue::Entity.from_record(record)
  end

  def add_event_for(issue, event)
    return false unless issue.persisted? || event.persisted?

    record = ::Event::Repository.insert(
      action: event.action,
      resource_id: issue.id,
      resource_type: "Issue::Record"
    )

    ::Issue::Event::Entity.from_record(record)
  end

  def load_events_for(issue)
    return [] unless issue.persisted?

    list = ::Event::List::Repository.load_all(
      resource_id: issue.id,
      resource_type: "Issue::Record"
    )

    binding.irb
    list.map { |record| ::Issue::Event::Entity.from_record(record) }
  end
end