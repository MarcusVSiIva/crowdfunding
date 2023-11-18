# frozen_string_literal: true

class SponsorshipsQuery < DefaultQuery
    def initialize(filters)
      super(filters)
  
      @filters = {
          page_number: filters[:pageNumber],
          items_per_page: filters[:itemsPerPage],
          project_id: filters[:projectId],
      }
    end

    attr_reader :filters

    def list
        base_query
            .order(amount: :desc)
            .page(@filters[:page_number])
            .per(@filters[:items_per_page])
    end

    delegate :count, to: :base_query

    def sum_amount
        base_query.sum(:amount)
    end

    private

    def base_query
        base_query ||= begin
            query = Sponsorship.all
            query = query.where(project_id: @filters[:project_id]) if @filters[:project_id].present?

            query
        end
    end
end