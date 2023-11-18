# frozen_string_literal: true

Rails.application.config.middleware.insert_before(0, Rack::Cors) do
    allow do
      # TODO: configure servers allowlist
      origins "*"
  
      resource "*",
        headers: :any,
        methods: [:get, :post, :patch, :put, :delete],
        expose: ["access-token", "expiry", "token-type", "uid", "client"]
    end
  end
  