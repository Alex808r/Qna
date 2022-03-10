# frozen_string_literal: true

class SphinxSearchService
  TYPES = %w[All Question Comment Answer User].freeze

  def initialize(params)
    @type = params[:type]
    @search_body = params[:search_body]
  end

  def call
    return [] if @search_body.empty?

    @type == 'All' ? ThinkingSphinx.search(@search_body) : Object.const_get(@type).search(@search_body)
  end
end
