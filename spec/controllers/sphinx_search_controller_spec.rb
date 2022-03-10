# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SphinxSearchController, type: :controller do
  describe 'GET #search' do
    before { get :search, params: { search_body: 'new search request', type: 'All' } }

    it 'returns 200 status' do
      expect(response.status).to eq successful
    end

    it 'render template search' do
      expect(response).to render_template :search
    end
  end
end
