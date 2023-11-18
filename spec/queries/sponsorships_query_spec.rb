# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SponsorshipsQuery, type: :query) do
    describe "#list" do
        context "when there are sponsorships" do
            it "returns a list of sponsorships" do
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")
                user2 = User.create!(email: "teste2@teste.com", password: "123456", name: "Teste2", nickname: "Teste2")

                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "um bolo")

                sponsorship = Sponsorship.create!(user: user, project: project, amount: 100)
                sponsorship2 = Sponsorship.create!(user: user2, project: project, amount: 50)

                query = SponsorshipsQuery.new({})
                result = query.list.to_a
                expect(result).to(eq([sponsorship, sponsorship2]))
            end
        end

        context "when there are no sponsorships" do
            it "returns an empty list" do
                query = SponsorshipsQuery.new({})
                result = query.list.to_a
                expect(result).to(eq([]))
            end
        end

        context "when filtering by project" do
            it "returns a list of sponsorships" do
                user = User.create!(email: "teste@teste.com", password: "123456", name: "Teste", nickname: "Teste")
                user2 = User.create!(email: "teste2@teste.com", password: "123456", name: "Teste2", nickname: "Teste2")

                project = Project.create!(name: "testezin", description: "Teste", active: true, goal: 100, reward: "um bolo")
                project2 = Project.create!(name: "testezin2", description: "Teste2", active: true, goal: 100, reward: "um bolo2")

                sponsorship = Sponsorship.create!(user: user, project: project, amount: 100)
                sponsorship2 = Sponsorship.create!(user: user2, project: project, amount: 50)
                other_sponsorship = Sponsorship.create!(user: user2, project: project2, amount: 50)

                query = SponsorshipsQuery.new({projectId: project.id})
                result = query.list.to_a
                expect(result).to(eq([sponsorship, sponsorship2]))
            end
        end
    end
end