require 'swagger_helper'

RSpec.describe 'API V1 Notifications', type: :request do
  path '/api/v1/notifications' do
    post 'Cria uma notificação' do
      tags 'Notifications'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :notification, in: :body, schema: {
        type:       :object,
        properties: {
          task_id:       { type: :string },
          user_id:       { type: :string },
          task_status:   { type: :string, enum: %w[in_progress completed failed], nullable: true },
          callback_data: { type: :object, additionalProperties: true }
        },
        required:   %w[task_id user_id] # Apenas task_id e user_id obrigatórios
      }

      response '202', 'Notificação criada' do
        schema type:       :object,
               properties: {
                 message: { type: :string, example: 'Notification processing initiated.' }
               },
               required:   ['message']

        let(:notification) { { task_id: '1', user_id: '1', task_status: 'in_progress', callback_data: { key: 'value' } } }
        run_test!
      end

      response '422', 'Parâmetros inválidos' do
        schema type:       :object,
               properties: {
                 errors: { type: :array, items: { type: :string }, example: ['Task ID não pode ser vazio', 'User ID inválido'] }
               },
               required:   ['errors']

        let(:notification) { { task_id: nil, user_id: nil } }
        run_test!
      end
    end
  end

  path '/api/v1/notifications/{id}' do
    put 'Atualiza uma notificação' do
      tags 'Notifications'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :notification, in: :body, schema: {
        type:       :object,
        properties: {
          task_status:   { type: :string, enum: %w[in_progress completed failed] },
          callback_data: { type: :object, additionalProperties: true }
        },
        required:   %w[] # No update required fields other than task_id from route
      }

      response '202', 'Notificação atualizada' do
        schema type:       :object,
               properties: {
                 message: { type: :string, example: 'Notification update processing initiated.' }
               },
               required:   ['message']

        let(:id) { Notification.create(task_id: '1', user_id: '1', task_status: 'in_progress').id }
        let(:notification) { { task_status: 'completed', callback_data: { new: 'data' } } }
        run_test!
      end

      response '422', 'Parâmetros inválidos' do
        schema type:       :object,
               properties: {
                 errors: { type: :array, items: { type: :string }, example: ['Task status não pode ser vazio'] }
               },
               required:   ['errors']

        let(:id) { Notification.create(task_id: '1', user_id: '1').id }
        let(:notification) { { task_status: nil } }
        run_test!
      end
    end
  end

  path '/api/v1/notifications/{id}/status' do
    get 'Consulta o status de uma notificação' do
      tags 'Notifications'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID da notificação'

      response '200', 'Status da notificação' do
        schema type:       :object,
               properties: {
                 task_id:     { type: :string },
                 task_status: { type: :string, enum: %w[in_progress completed failed] },
                 updated_at:  { type: :string, format: :date_time }
               },
               required:   %w[task_id task_status updated_at]

        let(:id) { Notification.create(task_id: '1', user_id: '1', task_status: 'in_progress', callback_data: { key: 'value' }).id }
        run_test!
      end

      response '404', 'Notificação não encontrada' do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end
  end
end
