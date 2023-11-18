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
              render json: {
                user: @resource,
              }
            end

            def render_create_error_bad_credentials
              render json: {
                messages: [I18n.t("devise_token_auth.sessions.bad_credentials")]
              }, status: :unauthorized
            end
        end
    end
end