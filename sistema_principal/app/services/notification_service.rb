require 'dry/monads'
require 'dry/monads/do'
require 'dry-initializer'

class NotificationService
  extend Dry::Initializer
  include Dry::Monads[:result]
  include Dry::Monads::Do

  # Definindo opções obrigatórias com dry-initializer
  option :task_id, proc(&:to_i), optional: false
  option :task_status, proc(&:to_s), optional: false
  option :user_id, proc(&:to_i), optional: false
  option :details, proc(&:to_json), optional: true

  def call
    yield validate_params
    task = yield find_task
    update_task_status_if_needed(task)

    Success("Task updated successfully.")
  rescue KeyError => e
    Failure("Missing required parameter: #{e.message}")
  rescue StandardError => e
    Failure("Internal server error: #{e.message}")
  end

  private

  def validate_params
    if task_id.zero? || task_status.empty? || user_id.zero?
      Failure("Missing required parameters: task_id, task_status, or user_id.")
    else
      Success()
    end
  end

  def find_task
    task = Task.find_by(id: task_id, user_id: user_id)
    task ? Success(task) : Failure("Task not found for user #{user_id}.")
  end

  def update_task_status_if_needed(task)
    if task.status != task_status
      if task.update({ status: task_status, details: JSON.parse(details) })
        Success(task)
      else
        Failure(task.errors.full_messages.join(', '))
      end
    else
      Success("No update needed. Status is already #{task_status}.")
    end
  end
end
