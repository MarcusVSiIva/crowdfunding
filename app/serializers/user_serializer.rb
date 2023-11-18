# frozen_string_literal: true

class UserSerializer < Blueprinter::Base
    view :index do
        transform CamelCaseTransformer

        association :users, blueprint: UserSerializer, view: :complete
        fields :count, :page_number, :items_per_page
    end

    view :complete do
        transform CamelCaseTransformer

        fields :id,
            :name,
            :email,
            :nickname,
            :image
    end
end