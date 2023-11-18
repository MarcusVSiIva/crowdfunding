# frozen_string_literal: true

module Api
    module Auth
        class SessionsController < DeviseTokenAuth::SessionsController
            def create
                super do |resource|
                  return render(
                    json: { messages: [I18n.t("devise.sessions.inactive_account")] },
                    status: :unauthorized,
                  ) unless resource.active?
                end
            end

            protected

            def render_create_success
              render json: ::UserSerializer.render(@resource, view: :complete)
            end

            def render_create_error_bad_credentials
              render json: {
                messages: [I18n.t("devise_token_auth.sessions.bad_credentials")]
              }, status: :unauthorized
            end

            def render_destroy_error
              render json: {
                messages: [I18n.t("devise_token_auth.sessions.user_not_found")]
              }, status: :not_found
            end
        end
    end
end