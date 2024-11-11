module ProcessTaskDefaultStatus
  extend ActiveSupport::Concern

  included do
    after_initialize :set_default_task_status, if: :new_record?
  end

  private

  def set_default_task_status
    self.task_status ||= :pending
  end
end
