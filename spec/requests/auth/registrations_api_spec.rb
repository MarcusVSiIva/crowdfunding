require 'rails_helper'

module Auth
    RSpec.describe 'Auth::Registrations', type: :request do
        describe 'POST /auth' do
            context "when try to register with valid data" do
                it "returns the user data with auth headers" do
                    params = {
                        email: "teste@gmail.com",
                        password: "12345678",
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:success)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            user: {
                                allow_password_change: false,
                                created_at: be_an(String),
                                email: "teste@gmail.com",
                                id: 1,
                                image: nil,
                                name: nil,
                                nickname: nil,
                                provider: "email",
                                uid: "teste@gmail.com",
                                updated_at: be_an(String),
                                role: "user",
                                active: true,
                            },
                        }
                    ))
                end
            end

            context "when registering a new user without password" do
                it "returns unprocessable entity" do
                    params = {
                        email: "teste@gmail.com",
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["Password can't be blank"],
                        }
                    ))
                end
            end

            context "when registering a new user without email" do
                it "returns unprocessable entity" do
                    params = {
                        name: "Teste",
                        nickname: "teste",
                        password: "12345678",
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["Email can't be blank"],
                        }
                    ))
                end
            end

            context "when registering a new user with invalid email" do
                it "returns unprocessable entity" do
                    params = {
                        email: "teste",
                        password: "12345678",
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["Email is not an email"],
                        }
                    ))
                end
            end

            context "when registering a new user with email already registered" do
                it "returns unprocessable entity" do
                    user = User.create!(email: "teste@gmail.com", password: "12345678")

                    params = {
                        email: "teste@gmail.com",
                        password: "12345678",
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["Email has already been taken"],
                        }
                    ))
                end
            end

            context "when registering a new user with invalid role" do
                it "returns unprocessable entity" do
                    params = {
                        email: "teste@gmail.com",
                        password: "12345678",
                        role: "admin"
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        messages: ["You are not allowed to sign up with this role."]
                    ))
                end
            end
        end

        describe 'PUT /auth' do
            context "when try to update user that exists with valid data" do
                it "returns the user data with auth headers" do
                    user = User.create!(email: "teste@gmail.com", password: "12345678")
                    auth_params = auth_params(user)

                    params = {
                        email: "new_email@gmail.com",
                    }

                    put "/api/auth/", params: params, headers: auth_params

                    expect(response).to have_http_status(:success)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            user: {
                                allow_password_change: false,
                                created_at: be_an(String),
                                email: "new_email@gmail.com",
                                id: 1,
                                image: nil,
                                name: nil,
                                nickname: nil,
                                provider: "email",
                                uid: "new_email@gmail.com",
                                updated_at: be_an(String),
                                role: "user",
                                active: true,
                            }
                        }
                    ))
                end
            end

            context "when try to update user that does not exists" do
                it "returns not found" do
                    params = {
                        email: "teste@teste.com",
                    }

                    put "/api/auth/", params: params

                    expect(response).to have_http_status(:not_found)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["User not found."],
                        }
                    ))
                end
            end

            context "when try to update user with invalid data" do
                it "returns unprocessable entity" do
                    user = User.create!(email: "teste@gmail.com", password: "12345678")
                    auth_params = auth_params(user)

                    params = {
                        role: "admin",
                    }

                    put "/api/auth/", params: params, headers: auth_params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["Please submit proper account update data in request body."]
                        }
                    ))
                end
            end
        end
    end
end