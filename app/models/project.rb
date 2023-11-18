# frozen_string_literal: true

class Project < ApplicationRecord
    scope :active, -> { where(active: true) }

    has_many :sponsorships
end