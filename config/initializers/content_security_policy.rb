# config/initializers/content_security_policy.rb

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https

    # FIX: Allow the browser to make requests to your local server
    # This resolves the "NetworkError" in Swagger
    policy.connect_src :self, :https, "http://localhost:3000", "ws://localhost:3000"
  end

  # This helps Rails 8 handle secure scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src)
end