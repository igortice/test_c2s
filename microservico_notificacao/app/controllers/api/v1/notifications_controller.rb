class Api::V1::NotificationsController < ApplicationController
  def create
    NotificationTaskJob.perform_later(notification_params, :create)

    render json: { message: "Notification processing initiated." }, status: :accepted
  end

  def update
    data = {
      id:            params[:id],
      task_status:   params[:task_status],
      callback_data: params[:callback_data]&.to_json
    }
    NotificationTaskJob.perform_later(data, :update)

    render json: { message: "Notification update processing initiated." }, status: :accepted
  end

  def status
    notification = Notification.find_by(id: params[:id])

    if notification
      render json: {
        task_id:     notification.task_id,
        task_status: notification.task_status,
        updated_at:  notification.updated_at
      }, status:   :ok
    else
      render json: { error: "Notification not found" }, status: :not_found
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:task_id, :task_status, :user_id, callback_data: {})
  end
end
