require 'swagger_helper'

RSpec.describe 'Todos API', type: :request do
  # Setup data for the tests
  let(:user) { create(:user) }
  let(:todo) { create(:todo, created_by: user.id) }
  let(:Authorization) { AuthenticateUser.new(user.email, user.password).call }

  path '/todos' do
    get('List todos') do
      tags 'Todos'
      security [bearer_auth: []]
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'

      response(200, 'successful') do
        let(:page) { 1 }
        run_test!
      end

      response(422, 'unauthorized') do
        let(:Authorization) { nil }
        let(:page) { 1 }
        run_test!
      end
    end

    post('Create a todo') do
      tags 'Todos'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :todo_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Learn Rails 8' },
          created_by: { type: :string, example: '1' }
        },
        required: ['title']
      }

      response(201, 'todo created') do
        let(:todo_params) { { title: 'New Swagger Todo', created_by: user.id.to_s } }
        run_test!
      end
    end
  end

  path '/todos/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Todo ID'

    get('Show a todo') do
      tags 'Todos'
      security [bearer_auth: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { todo.id }
        run_test!
      end

      response(404, 'todo not found') do
        let(:id) { 0 }
        run_test!
      end
    end

    put('Update a todo') do
      tags 'Todos'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :todo_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        }
      }

      response(204, 'todo updated') do
        let(:id) { todo.id }
        let(:todo_params) { { title: 'Updated Title' } }
        run_test!
      end
    end

    delete('Delete a todo') do
      tags 'Todos'
      security [bearer_auth: []]

      response(204, 'todo deleted') do
        let(:id) { todo.id }
        run_test!
      end
    end
  end
end