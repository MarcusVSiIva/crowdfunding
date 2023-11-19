require 'rails_helper'

RSpec.describe 'Users', type: :request do
    describe 'GET /users' do
        context "when there are users" do
            it "returns a JSON with the users" do
                user = User.create!(email: "teste@gmail.com", password: "12345678", name: "A")
                user2 = User.create!(email: "teste@teste.com", password: "12345678", name: "B")

                get "/api/users", headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        count: 2,
                        itemsPerPage: 30,
                        pageNumber: 1,
                        users: [
                            {
                                email: user.email,
                                id: user.id,
                                image: nil,
                                name: user.name,
                                nickname: nil,
                                active: true,
                                role: "user",
                            },
                            {
                                email: user2.email,
                                id: user2.id,
                                image: nil,
                                name: user2.name,
                                nickname: nil,
                                active: true,
                                role: "user",
                            },
                        ],
                    }
                ))
            end
        end
    end

    describe 'PUT /users/:id' do
        context "when the user exists" do
            it "updates the user" do
                user = User.create!(email: "teste@gmail.com", password: "12345678", name: "Teste")

                params = {
                    name: "Testezin",
                    nickname: "testezin"
                }

                put "/api/users/#{user.id}", params: params, headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        email: user.email,
                        name: params[:name],
                        nickname: params[:nickname],
                        image: nil,
                        id: user.id,
                        active: true,
                        role: "user",
                    }
                ))
            end
        end

        context "when the user does not exist" do
            it "returns a 404" do
                params = {
                    name: "Testezin",
                    nickname: "testezin"
                }

                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                put "/api/users/0", params: params, headers: user.create_new_auth_token

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["User not found"],
                    }
                ))
            end
        end

        context "when the user params are invalid" do
            it "returns a 422" do
                user = User.create!(email: "teste@teste.com", password: "12345678", name: "Teste")

                params = {
                    email: "teste.com"
                }

                put "/api/users/#{user.id}", params: params, headers: user.create_new_auth_token

                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Email is not an email"]
                    }
                ))
            end
        end

        context "when the email is already taken" do
            xit "returns a 422" do
                user = User.create!(email: "teste@teste.com", password: "12345678", name: "Teste")
                user2 = User.create!(email: "teste@gmail.com", password: "12345678", name: "Teste")

                params = {
                    email: user2.email
                }

                put "/api/users/#{user.id}", params: params, headers: user.create_new_auth_token

                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["Email has already been taken"]
                    }
                ))
            end
        end
    end

    describe 'DELETE /users/:id' do
        context "when the user exists" do
            it "deletes the user" do
                user = User.create!(email: "teste@teste.com", password: "12345678", name: "Teste")

                delete "/api/users/#{user.id}", headers: user.create_new_auth_token

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        email: user.email,
                        name: user.name,
                        nickname: nil,
                        active: false,
                        role: "user",
                        image: nil,
                        id: user.id,    
                    }
                ))
            end
        end

        context "when the user does not exist" do
            it "returns a 404" do
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")

                delete "/api/users/0", headers: user.create_new_auth_token

                expect(response).to have_http_status(:not_found)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        messages: ["User not found"],
                    }
                ))
            end
        end
    end
end