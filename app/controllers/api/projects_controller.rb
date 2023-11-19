# frozen_string_literal: true

module Api
    class ProjectsController < ApplicationController
        before_action :authenticate_api_user!
        before_action :authorize_admin!, only: [:update, :destroy]
        
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

        def update
            project = project_by_id!

            project.update!(project_params)

            render(json: ::ProjectSerializer.render(project, view: :complete))
        end

        def destroy
            project = project_by_id!

            project.update!(active: false)

            render(json: ::ProjectSerializer.render(project, view: :complete))
        end

        def show
            project = project_by_id!

            render(json: ::ProjectSerializer.render(project, view: :complete))
        end

        def list_sponsorships
            project = project_by_id!

            sponsorships = ::SponsorshipsQuery.new(request.query_parameters.merge(projectId: project.id))

            result = {
                sponsorships: sponsorships.list,
                count: sponsorships.count,
                page_number: sponsorships.filters[:page_number].to_i,
                items_per_page: sponsorships.filters[:items_per_page].to_i,
                total_amount: sponsorships.sum_amount,
            }

            render(json: ::SponsorshipSerializer.render(result, view: :index))
        end

        private

        def project_by_id!
            project = Project.find_by(id: params[:id])

            if project.blank?
                raise ActiveRecord::RecordNotFound, "#{I18n.t("models.project")} #{I18n.t("errors.not_found")}"
            end

            project
        end

        def project_params
            params.permit(:name, :description, :goal, :reward)
        end
    end
end