require 'rails_helper'

RSpec.describe 'Sponsorship', type: :request do
    describe 'POST /sponsorships' do
        context "when it has valid parameters" do
            it "creates the sponsorship with correct attributes" do
                user = User.create!(email: "teste@gmail.com", password: "12345678", name: "A")
                project = Project.create!(name: "Teste", description: "Teste", active: true, goal: 100, reward: "Teste")

                params = {
                    user_id: user.id,
                    project_id: project.id,
                    amount: 10.0
                }

                post "/api/sponsorships", params: params

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        id: be_an(Integer),
                        amount: params[:amount],
                        user: {
                            id: user.id,
                            name: user.name,
                            image: nil,
                            nickname: nil,
                            email: user.email,
                            role: "user",
                            active: true,
                        },
                        project: {
                            id: project.id,
                            name: project.name,
                            description: project.description,
                            reward: project.reward,
                            goal: project.goal,
                            active: true,
                        }
                    }
                ))
            end
        end

        context "when it has no user" do
            it "does not create sponsorship" do
                project = Project.create!(name: "Teste", description: "Teste", active: true, goal: 100, reward: "Teste")

                params = {
                    user_id: nil,
                    project_id: project.id,
                    amount: 10.0
                }

                post "/api/sponsorships", params: params

                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["User must exist"],
                    }
                ))
            end
        end

        context "when it has no project" do
            it "does not create sponsorship" do
                user = User.create!(email: "teste@gmail.com", password: "12345678", name: "A")

                params = {
                    user_id: user.id,
                    project_id: nil,
                    amount: 10.0
                }

                post "/api/sponsorships", params: params

                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Project must exist"],
                    }
                ))
            end
        end

        context "when it has no amount" do
            xit "does not create sponsorship" do
                user = User.create!(email: "teste@gmail.com", password: "12345678", name: "A")
                project = Project.create!(name: "Teste", description: "Teste", active: true, goal: 100, reward: "Teste")

                params = {
                    user_id: user.id,
                    project_id: project.id,
                    amount: nil
                }

                post "/api/sponsorships", params: params

                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Amount can't be blank"],
                    }
                ))
            end
        end
    end
end