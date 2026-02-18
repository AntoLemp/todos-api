require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/auth/login' do
    post('Login to get Token') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'ash@test.com' },
          password: { type: :string, example: 'foobar' }
        },
        required: %w[email password]
      }

      response(200, 'successful login') do
        # Create a user in the test database so the login test actually passes
        let!(:user) { create(:user, email: 'ash@test.com', password: 'password') }
        let(:credentials) { { email: 'ash@test.com', password: 'password' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        let(:credentials) { { email: 'wrong@test.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/auth/logout' do
    get('Logout user') do
      tags 'Authentication'
      security [bearer_auth: []]
      description 'Notifies the server to invalidate the session/token.'

      response(200, 'successful logout') do
        let(:user) { create(:user) }
        let(:Authorization) { AuthenticateUser.new(user.email, user.password).call[:auth_token] }
        run_test!
      end
    end
  end
end