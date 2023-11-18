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
        end
    end
end