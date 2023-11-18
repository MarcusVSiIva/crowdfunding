# frozen_string_literal: true

class DefaultQuery
    DEFAULT_PAGE_SIZE = 30
    DEFAULT_PAGE_NUMBER = 1
  
    def initialize(filters)
      filters[:itemsPerPage] =
        DEFAULT_PAGE_SIZE if filters[:itemsPerPage].blank? || filters[:itemsPerPage].to_i > DEFAULT_PAGE_SIZE
      filters[:pageNumber] = DEFAULT_PAGE_NUMBER if filters[:pageNumber].blank?
    end
end