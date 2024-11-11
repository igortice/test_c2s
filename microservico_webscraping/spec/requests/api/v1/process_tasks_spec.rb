require 'swagger_helper'

RSpec.describe 'API V1 ProcessTasks', type: :request do
  path '/api/v1/process_tasks' do
    post 'Create a new ProcessTask' do
      tags 'ProcessTasks'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :process_task, in: :body, schema: {
        type:       :object,
        properties: {
          task_url:        { type: :string },
          task_id:         { type: :integer }
        },
        required:   %w[task_url task_id]
      }

      response '201', 'ProcessTask created' do
        schema type:       :object,
               properties: {
                 message:      { type: :string, example: 'ProcessTask created successfully.' },
                 process_task: {
                   type:       :object,
                   properties: {
                     marca:           { type: :string, nullable: true },
                     modelo:          { type: :string, nullable: true },
                     valor:           { type: :string, nullable: true },
                     task_url:        { type: :string },
                     task_status:     { type: :integer },
                     task_id:         { type: :integer },
                     notification_id: { type: :integer },
                     created_at:      { type: :string, format: :datetime },
                     updated_at:      { type: :string, format: :datetime }
                   },
                   required:   %w[task_url task_id]
                 }
               }

        let(:process_task) { { task_url: 'https://example.com', task_id: 123 } }

        run_test!
      end

      response '422', 'Invalid request' do
        let(:process_task) { { task_url: '' } }
        run_test!
      end
    end
  end
end
