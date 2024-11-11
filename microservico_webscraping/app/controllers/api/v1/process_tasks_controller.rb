class Api::V1::ProcessTasksController < ApplicationController
  def create
    result = CreateProcessTaskService.new(params: process_task_params).call

    if result.success?
      render json: { message: "ProcessTask created successfully.", process_task: result.value! }, status: :created
    else
      render json: { errors: result.failure }, status: :unprocessable_entity
    end
  end

  private

  def process_task_params
    params
      .require(:process_task)
      .permit(:marca, :modelo, :valor, :task_url, :task_status, :task_id, :user_id, :notification_id)
  end
end
