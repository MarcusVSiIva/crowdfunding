# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ProjectsQuery, type: :query) do
    describe "#list" do
        context "when there are projects" do
            it "returns a list of projects" do
                project1 = Project.create!(name: "A", active: true)
                project2 = Project.create!(name: "B", active: true)

                query = ProjectsQuery.new({})
                result = query.list.to_a
                expect(result).to(eq([project1, project2]))
            end
        end

        context "when there are no projects" do
            it "returns an empty list" do
                query = ProjectsQuery.new({})
                result = query.list.to_a
                expect(result).to(eq([]))
            end
        end
    end
end