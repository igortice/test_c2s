require 'dry/monads'
require 'dry/monads/do'
require 'dry-initializer'
require 'faraday'

class CreateAndProcessTaskService
  extend Dry::Initializer
  include Dry::Monads[:result, :do]

  option :user, reader: :private
  option :task_params, reader: :private
  option :webscraping_service_url, default: -> { Rails.configuration.x.microservice_webscraping_url + '/api/v1/process_tasks' }

  def call
    task = yield create_task
    yield trigger_webscraping(task)

    Success("Task created and sent for processing successfully.")
  rescue StandardError => e
    Failure({ error: "Unexpected error occurred", details: e.message })
  end

  private

  def create_task
    task = user.tasks.new(task_params)

    if task.save
      Success(task)
    else
      Failure({ error: 'Failed to create task', details: task.errors.full_messages })
    end
  end

  def trigger_webscraping(task)
    response = Faraday.post(webscraping_service_url, {
      process_task: {
        task_id:  task.id,
        task_url: task.url,
        user_id:  task.user_id
      }
    }.to_json, 'Content-Type' => 'application/json')

    if response.success?
      Success(true)
    else
      Failure({ error: 'Failed to trigger web scraping', status: response.status, body: response.body })
    end
  rescue StandardError => e
    Failure({ error: 'Failed to trigger web scraping', details: e.message })
  end
end
