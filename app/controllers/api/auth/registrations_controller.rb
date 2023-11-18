# frozen_string_literal: true

module Api
    module Auth
        class RegistrationsController < DeviseTokenAuth::RegistrationsController
            before_action :validate_role, only: [:create]

            def destroy
              if @resource
                @resource.update!(active: false)
                yield @resource if block_given?
                render_destroy_success
              else
                render_destroy_error
              end
            end

            protected

            def render_create_success
              render json: ::UserSerializer.render(@resource, view: :complete)
            end

            def render_create_error
              render json: {
                messages: @resource.errors.full_messages
              }, status: 422
            end

            def render_update_success
              render json: ::UserSerializer.render(@resource, view: :complete)
            end

            def render_update_error_user_not_found
              render json: {
                messages: [I18n.t("devise_token_auth.registrations.user_not_found")]
              }, status: :not_found 
            end

            def account_update_params
              params.permit(*params_for_resource(:account_update), :email, :password, :password_confirmation, :name, :nickname, :image)
            end

            def render_destroy_success
              render json: ::UserSerializer.render(@resource, view: :complete)
            end
        
            def render_destroy_error
              render json: {
                messages: [I18n.t("devise_token_auth.registrations.account_to_destroy_not_found")]
              }, status: :not_found
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