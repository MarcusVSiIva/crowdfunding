# frozen_string_literal: true

module DefaultErrorHandleble
    extend ActiveSupport::Concern

    included do
        rescue_from ActiveRecord::RecordInvalid, with: :active_record_error_handler
        rescue_from ActiveRecord::RecordNotFound, with: :active_record_not_found_error_handler
    end

    private

    def active_record_not_found_error_handler(exception)
        render json: {
            messages: [exception.message]
        }, status: :not_found
    end

    def active_record_error_handler(exception)
        render json: {
            messages: exception.record.errors.full_messages
        }, status: :unprocessable_entity
    end
end