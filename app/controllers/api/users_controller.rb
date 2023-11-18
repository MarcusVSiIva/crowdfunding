# frozen_string_literal: true

module Api
    class UsersController < ApplicationController
        def index
            users = ::UsersQuery.new(request.query_parameters)
    
            result = {
              users: users.list,
              count: users.count,
              page_number: users.filters[:page_number].to_i,
              items_per_page: users.filters[:items_per_page].to_i,
            }
            
            render(json: ::UserSerializer.render(result, view: :index))
        end
    end
end