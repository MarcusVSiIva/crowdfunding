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

            def render_update_success
              render json: {
                user: @resource,
              }
            end

            def render_update_error_user_not_found
              render json: {
                messages: [I18n.t("devise_token_auth.registrations.user_not_found")]
              }, status: :not_found 
            end

            def account_update_params
              params.permit(*params_for_resource(:account_update), :email, :password, :password_confirmation, :name, :nickname, :image)
            end

            private

            def validate_role
                if params[:role].present? && params[:role] == "admin"
                  render json: {
                    messages: [I18n.t("devise.registrations.role_not_allowed")]
                  }, status: :unprocessable_entity
                end
            end

            def validate_post_data which, message
              render json: {
                messages: [message]
              }, status: :unprocessable_entity if which.empty?
            end
        end
    end
end