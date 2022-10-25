module Issue
  class Record < ApplicationRecord
    self.table_name = 'issues'

    validates_presence_of :number
    validates_uniqueness_of :number

    validates :title, presence: true

    has_many :events, foreign_key: :actionable_id, class_name: 'Event::Record'
  end
end
