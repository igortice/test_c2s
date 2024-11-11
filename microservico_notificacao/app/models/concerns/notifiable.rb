module Notifiable
  extend ActiveSupport::Concern

  included do
    after_commit :enqueue_notification_callback_job
  end

  private

  def enqueue_notification_callback_job
    NotificationTaskCallbackJob.perform_later(self) if persisted?
  end
end
