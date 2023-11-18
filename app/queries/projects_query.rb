# frozen_string_literal: true

class ProjectsQuery < DefaultQuery
    def initialize(filters)
      super(filters)
  
      @filters = {
          page_number: filters[:pageNumber],
          items_per_page: filters[:itemsPerPage],
      }
    end

    attr_reader :filters

    def list
        base_query
            .order(name: :asc)
            .page(@filters[:page_number])
            .per(@filters[:items_per_page])
    end

    delegate :count, to: :base_query

    private

    def base_query
        base_query = Project.active
    end
end