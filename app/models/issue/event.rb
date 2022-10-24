module Issue
  module Event
    ACTIONS = %w{
      opened
      edited
      deleted
      pinned
      unpinned
      closed
      reopened
      assigned
      unassigned
      labeled
      unlabeled
      locked
      unlocked
      transferred
      milestoned
      demilestone
    }.freeze
  end
end