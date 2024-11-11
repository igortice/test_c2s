require 'swagger_helper'

RSpec.describe 'API V1 Auth', type: :request do
  path '/api/v1/login' do
    post 'User Login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type:       :object,
        properties: {
          email:    { type: :string },
          password: { type: :string }
        },
        required:   %w[email password]
      }

      response '200', 'Login Successful' do
        schema type:       :object,
               properties: {
                 token: { type: :string },
                 user:  {
                   type:       :object,
                   properties: {
                     id:    { type: :integer },
                     name:  { type: :string },
                     email: { type: :string }
                   },
                   required:   %w[id name email]
                 }
               }

        let(:user) { create(:user, email: 'user@example.com', password: 'password') }
        let(:credentials) { { email: user.email, password: 'password' } }

        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:credentials) { { email: 'wrong@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/api/v1/validate_token' do
    get 'Validate Token' do
      tags 'Authentication'
      produces 'application/json'

      parameter name: :Authorization, in: :header, required: true, schema: {
        type:        :string,
        description: 'Bearer token'
      }

      response '200', 'Token valid' do
        schema type:       :object,
               properties: {
                 message: { type: :string, example: 'Token válido' },
                 user_id: { type: :integer, example: 1 }
               },
               required:   %w[message user_id]

        let(:Authorization) { "Bearer #{jwt_token}" }

        run_test!
      end

      response '401', 'Invalid or missing token' do
        schema type:       :object,
               properties: {
                 error: { type: :string, example: 'Invalid token' }
               }

        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end
end
