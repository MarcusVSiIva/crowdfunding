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
                            data: {
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
                            status: "success"
                        }
                    ))
                end
            end

            context "when registering a new user with invalid params" do
                it "returns unprocessable entity" do
                    params = {
                        email: "teste@gmail.com",
                    }

                    post "/api/auth", params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            data: {
                                allow_password_change: false,
                                created_at: nil,
                                email: "teste@gmail.com",
                                id: nil,
                                image: nil,
                                name: nil,
                                nickname: nil,
                                provider: "email",
                                uid: "",
                                updated_at: nil,
                                role: "user",
                                active: true,
                            },
                            errors: {
                                full_messages: [ "Password can't be blank" ],
                                password: [ "can't be blank" ]
                            },
                            status: "error"
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
    end
end