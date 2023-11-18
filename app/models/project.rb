# frozen_string_literal: true

class Project < ApplicationRecord
    scope :active, -> { where(active: true) }
end