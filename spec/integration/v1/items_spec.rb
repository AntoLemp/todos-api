require 'swagger_helper'

RSpec.describe 'Items API', type: :request do
  # Setup data for the tests
  let(:user) { create(:user) }
  let(:todo) { create(:todo, created_by: user.id) }
  let(:item) { create(:item, todo_id: todo.id) }
  let(:Authorization) { AuthenticateUser.new(user.email, user.password).call }

  path '/todos/{todo_id}/items' do
    parameter name: 'todo_id', in: :path, type: :integer, description: 'ID of the parent todo'

    get('List items for a todo') do
      tags 'Items'
      security [bearer_auth: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:todo_id) { todo.id }
        run_test!
      end

      response(422, 'unauthorized') do
        let(:todo_id) { todo.id }
        let(:Authorization) { nil }
        run_test!
      end
    end

    post('Create an item') do
      tags 'Items'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :item_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean }
        },
        required: ['name']
      }

      response(201, 'item created') do
        let(:todo_id) { todo.id }
        let(:item_params) { { name: 'Finish Swagger Docs', done: false } }
        run_test!
      end
    end
  end

  path '/todos/{todo_id}/items/{id}' do
    parameter name: 'todo_id', in: :path, type: :integer
    parameter name: 'id', in: :path, type: :integer

    get('Show item details') do
      tags 'Items'
      security [bearer_auth: []]

      response(200, 'successful') do
        let(:todo_id) { todo.id }
        let(:id) { item.id }
        run_test!
      end
    end

    put('Update an item') do
      tags 'Items'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :item_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean }
        }
      }

      response(204, 'item updated') do
        let(:todo_id) { todo.id }
        let(:id) { item.id }
        let(:item_params) { { done: true } }
        run_test!
      end
    end

    delete('Delete an item') do
      tags 'Items'
      security [bearer_auth: []]

      response(204, 'item deleted') do
        let(:todo_id) { todo.id }
        let(:id) { item.id }
        run_test!
      end
    end
  end
end
