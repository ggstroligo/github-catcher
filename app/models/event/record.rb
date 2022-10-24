module Event
  class Record < ApplicationRecord
    self.table_name = 'events'

    belongs_to :actionable, polymorphic: true
  end
end
