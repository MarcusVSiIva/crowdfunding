require 'rails_helper'

RSpec.describe 'Projects', type: :request do
    describe 'GET /projects' do
        context "when there are projects" do
            it "returns a JSON with the projects" do
                project = Project.create!(name: "Teste", description: "Teste", active: true, goal: 100, reward: "Teste")
                project2 = Project.create!(name: "Teste2", description: "Teste2", active: true, goal: 100, reward: "Teste2")

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                get "/api/projects", headers: user.create_new_auth_token

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
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                get "/api/projects", headers: user.create_new_auth_token

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

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                post "/api/projects", params: params, headers: user.create_new_auth_token

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

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                put "/api/projects/#{project.id}", params: params, headers: user.create_new_auth_token

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

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                put "/api/projects/0", params: params, headers: user.create_new_auth_token

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Project not found"], 
                    }
                ))
            end
        end
    end

    describe 'DELETE /projects/:id' do
        context "when the project exists" do
            it "deletes the project" do
                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "Teste")

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                delete "/api/projects/#{project.id}", headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        name: project.name,
                        id: project.id,
                        description: project.description,
                        goal: project.goal,
                        reward: project.reward,
                        active: false,
                    }
                ))
            end
        end

        context "when the project does not exist" do
            it "returns status code 404" do
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                delete "/api/projects/0", headers: user.create_new_auth_token

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Project not found"],
                    }
                ))  
            end
        end
    end

    describe 'GET /projects/:id' do
        context "when the project exists" do
            it "returns the project" do
                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "Teste")

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                get "/api/projects/#{project.id}", headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        name: project.name,
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
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                get "/api/projects/0", headers: user.create_new_auth_token

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Project not found"],
                    }
                ))
            end
        end
    end

    describe 'GET /projects/:id/sponsorships' do
        context "when the project exists" do
            it "returns the project's sponsorships" do
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")
                user2 = User.create!(email: "teste2@teste.com", password: "123456", name: "Teste2", nickname: "Teste2")

                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "um bolo")
                project2 = Project.create!(name: "testezin2", description: "Teste2", active: true, goal: 100, reward: "um bolo2")

                sponsorship = Sponsorship.create!(user: user, project: project, amount: 100)
                sponsorship2 = Sponsorship.create!(user: user2, project: project, amount: 50)
                other_sponsorship = Sponsorship.create!(user: user2, project: project2, amount: 50)

                get "/api/projects/#{project.id}/sponsorships", headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        count: 2,
                        itemsPerPage: 30,
                        pageNumber: 1,
                        totalAmount: 150.0,
                        sponsorships: [
                            {
                                amount: sponsorship.amount,
                                id: sponsorship.id,
                                user: {
                                    id: user.id,
                                    name: user.name,
                                    nickname: user.nickname,
                                    email: user.email,
                                    image: nil,
                                    active: true,
                                    role: "user",
                                },
                            },
                            {
                                amount: sponsorship2.amount,
                                id: sponsorship2.id,
                                user: {
                                    id: user2.id,
                                    email: user2.email,
                                    nickname: user2.nickname,
                                    name: user2.name,
                                    image: nil,
                                    active: true,
                                    role: "user",
                                },
                            },
                        ],
                    }
                ))
            end
        end

        context "when the project does not exist" do
            it "returns status code 404" do
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                get "/api/projects/0/sponsorships", headers: user.create_new_auth_token

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Project not found"],
                    }
                ))
            end
        end

        context "when the project has no sponsorships" do
            it "returns an empty JSON" do
                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "um bolo")
                
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                get "/api/projects/#{project.id}/sponsorships", headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        count: 0,
                        itemsPerPage: 30,
                        pageNumber: 1,
                        sponsorships: [],
                        totalAmount: 0.0,
                    }
                ))
            end
        end
    end
end