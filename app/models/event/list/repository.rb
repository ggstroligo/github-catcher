module Event
  module List
    module Repository
      module_function

      def load_all(resource_id:, resource_type:)
        return ::Event::Record.all if resource_id.blank? || resource_type.blank?

        ::Event::Record.where(actionable_id: resource_id, actionable_type: resource_type)
      end
    end
  end
end