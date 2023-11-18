# frozen_string_literal: true

class SponsorshipSerializer < Blueprinter::Base
    view :complete do
        identifier :id

        fields :amount

        association :user, blueprint: UserSerializer, view: :complete
        association :project, blueprint: ProjectSerializer, view: :complete
    end
end