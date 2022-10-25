module Event
  class Record < ApplicationRecord
    self.table_name = 'events'

    validates_presence_of :action

    belongs_to :actionable, polymorphic: true
  end
end
