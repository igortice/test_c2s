module Broadcastable
  extend ActiveSupport::Concern

  included do
    after_update_commit :broadcast_status_update
  end

  private

  def broadcast_status_update
    ActionCable.server.broadcast("task_status_channel_user_#{user_id}", { task_id: id, status: status })
  end
end
