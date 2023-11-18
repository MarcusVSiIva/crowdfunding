# frozen_string_literal: true

class SponsorshipSerializer < Blueprinter::Base
    view :index do
        transform CamelCaseTransformer

        association :sponsorships, blueprint: SponsorshipSerializer, view: :complete
        fields :count, :page_number, :items_per_page, :total_amount

        exclude :id
    end

    view :complete do
        transform CamelCaseTransformer

        identifier :id

        fields :amount

        association :user, blueprint: UserSerializer, view: :complete
    end
end