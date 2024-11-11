module ValidatableNotification
  extend ActiveSupport::Concern

  included do
    validates :task_id, :user_id, presence: true
  end
end
