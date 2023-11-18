require 'rails_helper'

RSpec.describe 'Projects', type: :request do
    describe 'GET /projects' do
        context "when there are projects" do
            it "returns a JSON with the projects" do
                project = Project.create!(name: "Teste", description: "Teste", active: true, goal: 100, reward: "Teste")
                project2 = Project.create!(name: "Teste2", description: "Teste2", active: true, goal: 100, reward: "Teste2")

                get "/api/projects"

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        count: 2,
                        itemsPerPage: 30,
                        pageNumber: 1,
                        projects: [
                            {
                                id: project.id,
                                name: project.name,
                                description: project.description,
                                active: project.active,
                                goal: project.goal,
                                reward: project.reward,
                            },
                            {
                                id: project2.id,
                                name: project2.name,
                                description: project2.description,
                                active: project2.active,
                                goal: project2.goal,
                                reward: project2.reward,
                            },
                        ],
                    }
                ))
            end
        end

        context "when there are no projects" do
            it "returns an empty JSON" do
                get "/api/projects"

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        count: 0,
                        itemsPerPage: 30,
                        pageNumber: 1,
                        projects: [],
                    }
                ))
            end
        end
    end

    describe 'POST /projects' do
        context "when it has valid parameters" do
            it "creates the project with correct attributes" do
                params = {
                    name: "Teste",
                    description: "Teste",
                    goal: 100,
                    reward: "Teste",
                }

                post "/api/projects", params: params

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        id: be_an(Integer),
                        name: params[:name],
                        description: params[:description],
                        goal: params[:goal],
                        reward: params[:reward],
                        active: true,
                    }
                ))
            end
        end
    end

    describe 'PUT /projects/:id' do
        context "when the project exists" do
            it "updates the project" do
                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "Teste")

                params = {
                    name: "Teste",
                }

                put "/api/projects/#{project.id}", params: params

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        name: params[:name],
                        id: project.id,
                        description: project.description,
                        goal: project.goal,
                        reward: project.reward,
                        active: project.active,
                    }
                ))
            end
        end

        context "when the project does not exist" do
            it "returns status code 404" do
                params = {
                    name: "Teste",
                }

                put "/api/projects/0", params: params

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Project not found"], 
                    }
                ))
            end
        end
    end
end