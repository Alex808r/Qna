# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    # context 'unauthorized' do
    #   it 'returns 401 status if there is no access_token' do
    #     get '/api/v1/profiles/me', headers: headers
    #     expect(response.status).to eq 401
    #   end
    #
    #   it 'returns 401 status if access_token invalid' do
    #     get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      # before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }
      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Status be_successful'

      # it 'returns 200 status' do
      #   expect(response).to be_successful
      # end

      it_behaves_like 'Return public fields' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:response_resource) { json['user'] }
        let(:resource) { me }
      end

      it_behaves_like 'Return private fields'
    end

    # it 'returns all public fields' do
    #   %w[id email admin created_at updated_at].each do |attr|
    #     expect(json[attr]).to eq me.send(attr).as_json
    #   end
    # end
    #
    # it 'dose not return private fields' do
    #   %w[password encrypted_password].each do |attr|
    #     expect(json).to_not have_key(attr)
    #   end
    # end
  end

  describe 'GET /api/v1/profiles/all_users' do
    let(:api_path) { '/api/v1/profiles/all_users' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { json['users'] }
        let(:resource) { User.count - 1 }
      end

      it 'does not contains current_user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it_behaves_like 'Return public fields' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:response_resource) { json['users'].last }
        let(:resource) { user }
      end

      it_behaves_like 'Return private fields'
    end
  end
end
