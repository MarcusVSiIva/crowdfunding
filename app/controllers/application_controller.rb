# frozen_string_literal: true

class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken
        include DefaultErrorHandleble
        skip_before_action :verify_authenticity_token

        def authorize_admin!
                unless current_api_user.role == "admin"
                    render json: {
                        messages: ["#{I18n.t("errors.forbidden")}"]
                    }, status: :forbidden
                end
        end
end
