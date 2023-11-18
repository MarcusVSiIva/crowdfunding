# frozen_string_literal: true

class Sponsorship < ApplicationRecord
    belongs_to :user
    belongs_to :project
end