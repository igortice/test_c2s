module DefaultStatus
  extend ActiveSupport::Concern

  included do
    after_initialize :set_default_task_status, if: :new_record?
  end

  private

  def set_default_task_status
    self.task_status ||= :in_progress
  end
end
