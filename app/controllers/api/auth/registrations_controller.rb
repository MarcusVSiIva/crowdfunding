# frozen_string_literal: true

module Api
    module Auth
        class RegistrationsController < DeviseTokenAuth::RegistrationsController
            before_action :validate_role, only: [:create]

            protected

            def render_create_success
              render json: {
                user: @resource,
              }
            end

            def render_create_error
              render json: {
                messages: @resource.errors.full_messages
              }, status: 422
            end

            private

            def validate_role
                if params[:role].present? && params[:role] == "admin"
                  render json: {
                    messages: [I18n.t("devise.registrations.role_not_allowed")]
                  }, status: :unprocessable_entity
                end
            end
        end
    end
end