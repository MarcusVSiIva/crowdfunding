# frozen_string_literal: true

class ProjectSerializer < Blueprinter::Base
    view :index do
        transform CamelCaseTransformer

        association :projects, blueprint: ProjectSerializer, view: :complete
        fields :count, :page_number, :items_per_page
    end

    view :complete do
        fields :id,
            :name,
            :description,
            :active,
            :goal,
            :reward
    end
end