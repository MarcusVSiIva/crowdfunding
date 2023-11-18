# frozen_string_literal: true

module Api
    class ProjectsController < ApplicationController
        def index
            projects = ::ProjectsQuery.new(request.query_parameters)

            result = {
                projects: projects.list,
                count: projects.count,
                page_number: projects.filters[:page_number].to_i,
                items_per_page: projects.filters[:items_per_page].to_i,
            }

            render(json: ::ProjectSerializer.render(result, view: :index))
        end

        def create
            project = Project.new(project_params)

            project.save!
            
            render(json: ::ProjectSerializer.render(project, view: :complete))
        end

        private

        def project_params
            params.permit(:name, :description, :active, :goal, :reward)
        end
    end
end