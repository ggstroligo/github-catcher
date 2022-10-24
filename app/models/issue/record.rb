module Issue
  class Record < ApplicationRecord
    self.table_name = 'issues'

    validates :number, uniqueness: true, presence: true
    validates :title, presence: true

    has_many :events, foreign_key: :actionable_id, class_name: 'Event::Record'
  end
end
