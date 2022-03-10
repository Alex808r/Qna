# frozen_string_literal: true

class SphinxSearchController < ApplicationController
  skip_authorization_check

  def search
    service = SphinxSearchService.new(search_params)
    @result = service.call
  end

  private

  def search_params
    params.permit(:search_body, :type)
  end
end
