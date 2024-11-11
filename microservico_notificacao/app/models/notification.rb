class Notification < ApplicationRecord
  enum task_status: { pending: 0, in_progress: 1, completed: 2, failed: 3 }

  include ValidatableNotification
  include DefaultStatus
  include Notifiable
end
