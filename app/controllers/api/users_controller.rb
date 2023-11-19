# frozen_string_literal: true

module Api
    class UsersController < ApplicationController
        before_action :authenticate_api_user!
        
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
            user = user_by_id!

            if User.exists?(email: params[:email]) && User.find_by(email: params[:email]).id != user.id
                render json: {
                  messages: ["#{I18n.t("models.email")} #{I18n.t("errors.taken")}"]
                }, status: :unprocessable_entity
            elsif user.update(user_params)
                render(json: ::UserSerializer.render(user, view: :complete))
            else
                render json: {
                    messages: user.errors.full_messages
                }, status: :unprocessable_entity
            end
        end

        def destroy
            user = user_by_id!

            user.update!(active: false)

            render(json: ::UserSerializer.render(user, view: :complete))
        end
        
        private
          
        def user_by_id!
            user = User.find_by(id: params[:id])
            
            if user.blank?
                raise ActiveRecord::RecordNotFound, "#{I18n.t("models.user")} #{I18n.t("errors.not_found")}"
            end
        
            user
        end
        
        def user_params
            params.permit(:name, :email, :password, :nickname, :image, :active)
        end
    end
end