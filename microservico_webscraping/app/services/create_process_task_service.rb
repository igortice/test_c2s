# app/services/create_process_task_service.rb
require 'dry/monads'
require 'dry/monads/do'
require 'dry-initializer'

class CreateProcessTaskService
  extend Dry::Initializer
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  # Define os parâmetros necessários com dry-initializer
  option :params, reader: :private

  def call
    validated_params = yield validate_params(params)
    process_task     = yield create_process_task(validated_params)

    Success(process_task)
  end

  private

  def validate_params(params)
    # Aqui você pode adicionar validações personalizadas se necessário
    if params[:task_url].present? && params[:task_id].present?
      Success(params)
    else
      Failure(["Task URL and Task ID are required"])
    end
  end

  def create_process_task(validated_params)
    process_task = ProcessTask.new(validated_params)

    if process_task.save
      Success(process_task)
    else
      Failure(process_task.errors.full_messages)
    end
  end
end
