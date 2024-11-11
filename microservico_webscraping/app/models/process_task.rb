class ProcessTask < ApplicationRecord
  enum task_status: { pending: 0, in_progress: 1, completed: 2, failed: 3 }

  include ProcessTaskValidations
  include ProcessTaskHelpers
  include ProcessTaskDefaultStatus
  include TaskJobEnqueueable
end
