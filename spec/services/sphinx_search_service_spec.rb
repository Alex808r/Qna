# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SphinxSearchService do
  it 'have method call' do
    SphinxSearchService.new(search_body: 'object', type: 'Question').call
  end
end
