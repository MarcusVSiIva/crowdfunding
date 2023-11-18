require 'rails_helper'

module Auth
    RSpec.describe 'Auth::Sessions', type: :request do
        describe 'POST /auth/sign_in' do
            context "when try to login with valid data" do
                it "returns the user data with auth headers" do
                    user = User.create!(email: "teste@gmail.com", password: "12345678")

                    post "/api/auth/sign_in", params: {
                        email: user.email,
                        password: user.password,
                    }

                    expect(response).to have_http_status(:success)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            active: true,
                            email: "teste@gmail.com",
                            id: be_an(Integer),
                            image: nil,
                            name: nil,
                            nickname: nil,
                            role: "user",
                        }
                    ))
                end
            end

            context "when try to login with invalid data" do
                it "returns unauthorized" do
                    post "/api/auth/sign_in", params: {
                        email: "teste@gmail.com",
                        password: "12345678",
                    }

                    expect(response).to have_http_status(:unauthorized)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["Invalid login credentials. Please try again."],
                        }
                    ))
                end
            end

            context "when try to login with inactive account" do
                it "returns unauthorized" do
                    user = User.create!(email: "teste@gmail.com", password: "12345678", active: false)

                    post "/api/auth/sign_in", params: {
                        email: user.email,
                        password: user.password,
                    }

                    expect(response).to have_http_status(:unauthorized)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        messages: ["Your account is not activated"],
                    ))
                end
            end
        end

        describe 'DELETE /auth/sign_out' do
            context "when try to logout with valid data" do
                it "returns success" do
                    user = User.create!(email: "teste@teste.com", password: "12345678")
                    auth_params = auth_params(user)

                    delete "/api/auth/sign_out", headers: auth_params

                    expect(response).to have_http_status(:success)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            success: true,
                        }
                    ))
                end
            end

            context "when try to logout with invalid data" do
                it "returns not found" do
                    delete "/api/auth/sign_out"

                    expect(response).to have_http_status(:not_found)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["User was not found or was not logged in."],
                        }
                    ))
                end
            end

            context "when trying to access an authenticated route after logout" do
                xit "returns unauthorized" do
                    user = User.create!(email: "teste@teste.com", password: "12345678")
                    auth_params = auth_params(user)

                    delete "/api/auth/sign_out", headers: auth_params

                    get "/api/users", headers: auth_params

                    expect(response).to have_http_status(:unauthorized)
                    expect(response.parsed_body.deep_symbolize_keys).to(match(
                        {
                            messages: ["You need to sign in or sign up before continuing."],
                        }
                    ))
                end
            end
        end
    end
end