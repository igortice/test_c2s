class NotificationTaskCallbackJob < ApplicationJob
  queue_as :projeto1_default

  def perform(notification)
    send_callback(notification)
  end

  private

  def send_callback(notification)
    callback_url = Rails.configuration.x.sistema_principal_url + "/tasks/notification_callback"
    payload      = {
      task_id:       notification.task_id,
      task_status:   notification.task_status,
      user_id:       notification.user_id,
      callback_data: notification.callback_data
    }

    begin
      response = Faraday.post(callback_url) do |req|
        req.headers["Content-Type"] = "application/json"
        req.body                    = payload.to_json
      end

      if response.success?
        Rails.logger.info "Callback response: #{response.status} - #{response.body}"
      else
        Rails.logger.error "Callback failed with status: #{response.status}"
      end
    rescue Faraday::Error => e
      Rails.logger.error "Failed to send callback: #{e.message}"
    end
  end
end
