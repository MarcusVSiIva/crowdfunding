require 'rails_helper'

RSpec.describe 'Users', type: :request do
    describe 'GET /users' do
        context "when there are users" do
            it "returns a JSON with the users" do
                user = User.create!(email: "teste@gmail.com", password: "12345678")
                user2 = User.create!(email: "teste@teste.com", password: "12345678")

                get "/api/users"

                expect(response).to have_http_status(:success)
                expect(response.parsed_body.deep_symbolize_keys).to(match(
                    {
                        users: be_an(Array),
                        count: 2,
                        itemsPerPage: 30,
                        pageNumber: 1,
                    }
                ))
            end
        end
    end
end