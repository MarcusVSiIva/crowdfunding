# frozen_string_literal: true

module Api
    class SponsorshipsController < ApplicationController
        def create
            sponsorship = Sponsorship.new(sponsorship_params)

            sponsorship.save!
            
            render(json: ::SponsorshipSerializer.render(sponsorship, view: :complete))
        end

        private

        def sponsorship_params
            params.permit(:user_id, :project_id, :amount)
        end
    end
end