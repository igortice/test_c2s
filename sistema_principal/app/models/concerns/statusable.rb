module Statusable
  extend ActiveSupport::Concern

  included do
    enum status: { pending: 0, in_progress: 1, completed: 2, failed: 3 }

    before_create :set_default_status
  end

  STATUSES = {
    "pending"     => "bg-warning text-dark",
    "in_progress" => "bg-primary",
    "completed"   => "bg-success",
    "failed"      => "bg-danger"
  }.freeze

  def status_badge_class
    STATUSES[status] || "bg-secondary"
  end

  private

  def set_default_status
    self.status ||= "pending"
  end
end
