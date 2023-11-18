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

        def update 
            user = user_by_id
            
            if user.update!(user_params)
                render(json: ::UserSerializer.render(user, view: :complete))
            else
                render json: {
                    messages: user.errors.full_messages
                }, status: :unprocessable_entity
            end
        end
        
        private
          
        def user_by_id
            user = User.find_by(id: params[:id])
            
            if user.blank?
                raise ActiveRecord::RecordNotFound, "#{I18n.t("models.user")} #{I18n.t("errors.not_found")}"
            end
        
            user
        end
        
        def user_params
            params.permit(:name, :email, :password, :nickname, :image)
        end
    end
end