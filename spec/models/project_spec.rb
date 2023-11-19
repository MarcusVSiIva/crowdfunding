# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project, type: :model do
    describe "scopes" do
        describe ".active" do
            it "returns only active projects" do
                active_project = Project.create(name: "Active Project", active: true)
                Project.create(name: "Inactive Project", active: false)
                expect(Project.active).to eq([active_project])
            end
        end
    end
end