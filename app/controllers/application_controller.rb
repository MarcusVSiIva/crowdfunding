# frozen_string_literal: true

class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken
        include DefaultErrorHandleble
        skip_before_action :verify_authenticity_token
end
