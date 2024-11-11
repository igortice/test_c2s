class TaskStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "task_status_channel_user_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
