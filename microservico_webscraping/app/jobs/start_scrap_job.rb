require "faraday"
require "nokogiri"

class StartScrapJob < ApplicationJob
  queue_as :projeto2_default

  def perform(id)
    process_task = ProcessTask.find(id)
    host         = Rails.configuration.x.microservice_notification_url

    # Passo 1: Notificar o início do scraping via POST
    notification_id = create_notification(process_task, host)

    # Passo 2: Realizar o scraping usando WebScraperService
    scraped_data = WebScraperService.new(url: process_task.task_url).call

    if scraped_data.success?
      details     = scraped_data.value!
      update_data = {
        marca:  details.dig(:marca),
        modelo: details.dig(:modelo),
        valor:  details.dig(:preco),
      }
      # Atualizar a task localmente com os dados raspados
      process_task.update(update_data.merge(task_status: "completed"))

      # Passo 3: Atualizar notificação via PUT com status 'completed' e detalhes
      create_notification(process_task, host, "completed")
    else
      # Atualizar a task localmente em caso de falha no scraping
      # process_task.update(status: "failed")
      #
      # # Passo 3: Atualizar notificação via PUT com status 'failed'
      # update_notification(notification_id, "failed", nil, host)
    end
    # rescue ActiveRecord::RecordNotFound => e
    #   Rails.logger.error "Task not found: #{e.message}"
    # rescue StandardError => e
    #   Rails.logger.error "Error during scraping task #{task_id}: #{e.message}"
    #   update_notification(notification_id, "failed", nil, host) if notification_id
  end

  private

  # Método para criar a notificação (POST)
  def create_notification(process_task, host, status = "in_progress")
    url     = "#{host}/api/v1/notifications"
    payload = {
      task_id:       process_task.task_id,
      user_id:       process_task.user_id,
      task_status:   status,
      callback_data: {
        marca:  process_task&.marca,
        modelo: process_task&.modelo,
        preco:  process_task&.valor
      }
    }.compact.to_json

    response = Faraday.post(url, payload, "Content-Type" => "application/json")

    if response.success?
      JSON.parse(response.body)["id"] # Assume que o ID da notificação é retornado
    else
      Rails.logger.error "Failed to create notification: #{response.status} - #{response.body}"
      nil
    end
  rescue Faraday::Error => e
    Rails.logger.error "Connection error during notification creation: #{e.message}"
    nil
  end

  # Método para atualizar a notificação (PUT)
  def update_notification(notification_id, status, update_data, host)
    url     = "#{host}/api/v1/notifications/#{notification_id}"
    payload = {
      task_status:   status,
      callback_data: {
        marca:  update_data&.dig(:marca),
        modelo: update_data&.dig(:modelo),
        preco:  update_data&.dig(:valor)
      }
    }.compact.to_json

    Rails.logger.info "Atual update_notification: #{url} - #{payload}"

    # response = Faraday.put(url, payload, "Content-Type" => "application/json")
    #
    # unless response.success?
    #   Rails.logger.error "Failed to update notification: #{response.status} - #{response.body}"
    # end
  rescue Faraday::Error => e
    Rails.logger.error "Connection error during notification update: #{e.message}"
  end
end
