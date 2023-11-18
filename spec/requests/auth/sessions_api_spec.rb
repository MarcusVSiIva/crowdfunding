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
                            data: {
                                allow_password_change: false,
                                email: "teste@gmail.com",
                                id: 1,
                                image: nil,
                                name: nil,
                                nickname: nil,
                                provider: "email",
                                uid: "teste@gmail.com",
                                role: "user",
                                active: true,
                            },
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
                            errors: ["Invalid login credentials. Please try again."],
                            success: false,
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
    end
end