# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersQuery, type: :query) do
    describe "#list" do
        context "when there are users" do
            it "returns a list of users" do
                user1 = User.create!(email: "teste@teste.com", password: "12345678", name: "A")
                user2 = User.create!(email: "teste@gmail.com", password: "12345678", name: "B")

                query = UsersQuery.new({})
                result = query.list.to_a
                expect(result).to(eq([user1, user2]))
            end
        end

        context "when there are no users" do
            it "returns an empty list" do
                query = UsersQuery.new({})
                result = query.list.to_a
                expect(result).to(eq([]))
            end
        end
    end
end