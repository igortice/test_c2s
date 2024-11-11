class NotificationTaskJob < ApplicationJob
  queue_as :projeto1_default

  rescue_from(StandardError) do |exception|
    Rails.logger.error("NotificationTaskJob failed: #{exception.message}")
    retry_job wait: 5.minutes, queue: :low_priority if executions < 3
  end

  def perform(notification_params, type)
    process_notification(notification_params, type.to_sym)
  rescue ActiveRecord::RecordInvalid => e
    log_error("Failed to process notification", e)
  end

  private

  def process_notification(notification_params, action)
    notification =
      case action
      when :create
        Notification.new(notification_params)
      when :update
        Notification.find_by!(id: notification_params[:id]).tap do |record|
          record.assign_attributes(task_status: notification_params[:task_status], callback_data: notification_params[:callback_data])
        end
      else
        raise ArgumentError, "Invalid action: #{action}"
      end

    if notification.save
      log_success(action, notification)
      send_callback(notification)
    else
      log_failure(action, notification)
      Failure(notification.errors.full_messages)
    end
  end

  def log_success(action, notification)
    Rails.logger.info "Notification #{action}d successfully. ID: #{notification.id}"
  end

  def log_failure(action, notification)
    Rails.logger.error "Failed to #{action} notification: #{notification.errors.full_messages.join(', ')}"
  end

  def log_error(message, exception)
    Rails.logger.error("#{message}: #{exception.message}")
  end

  def send_callback(notification)
    # Simulate sending callback
    Rails.logger.info "Callback sent for Notification ID: #{notification.id}"
  end
end
