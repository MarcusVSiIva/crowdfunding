# frozen_string_literal: true

module Api
    module Auth
        class SessionsController < DeviseTokenAuth::SessionsController 
        end
    end
end