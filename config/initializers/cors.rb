Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # In production, you'd change this to your actual domain

    resource "*",
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end