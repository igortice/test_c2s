require 'swagger_helper'

RSpec.describe 'API V1 Users', type: :request do
  path '/api/v1/users' do
    post 'Create a User' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type:       :object,
        properties: {
          name:                  { type: :string },
          email:                 { type: :string },
          password:              { type: :string },
          password_confirmation: { type: :string }
        },
        required:   %w[name email password password_confirmation]
      }

      response '201', 'User created successfully' do
        schema type:       :object,
               properties: {
                 message: { type: :string },
                 user:    {
                   type:       :object,
                   properties: {
                     id:    { type: :integer },
                     name:  { type: :string },
                     email: { type: :string }
                   },
                   required:   %w[id name email]
                 }
               }

        let(:user) do
          {
            user: {
              name:                  'Test User',
              email:                 'user@example.com',
              password:              'password',
              password_confirmation: 'password'
            }
          }
        end
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema type:       :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               }

        let(:user) do
          {
            user: {
              name:                  '',
              email:                 'user@example.com',
              password:              'short',
              password_confirmation: 'different'
            }
          }
        end
        run_test!
      end
    end
  end
end
