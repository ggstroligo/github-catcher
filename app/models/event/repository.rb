module Event
  module Repository
    module_function

    def insert(action:, resource_id:, resource_type:)
      ::Event::Record.create!(
        action: action,
        actionable_id: resource_id,
        actionable_type: resource_type
      )
    end
  end
end