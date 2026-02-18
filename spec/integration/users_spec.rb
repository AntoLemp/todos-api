require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/signup' do
    post('Create User / Signup') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      # Define the request body schema
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Ash Ketchum' },
          email: { type: :string, example: 'ash@test.com' },
          password: { type: :string, example: 'foobar' },
          password_confirmation: { type: :string, example: 'foobar' }
        },
        required: %w[name email password password_confirmation]
      }

      response(201, 'User created successfully') do
        let(:user_params) do
          {
            name: 'Ash',
            email: 'ash@test.com',
            password: 'password',
            password_confirmation: 'password'
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'Validation Failed') do
        let(:user_params) { { name: 'Ash' } }
        run_test!
      end
    end
  end
end