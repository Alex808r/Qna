# frozen_string_literal: true

shared_examples_for 'API authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Status be_successful' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Return public fields' do
  it 'returns all public fields' do
    attributes.each do |attr|
      expect(response_resource[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'Return private fields' do
  it 'dose not return private fields' do
    %w[password encrypted_password].each do |attr|
      expect(json).to_not have_key(attr)
    end
  end
end

shared_examples_for 'Return list of objects' do
  it 'returns list of items' do
    expect(responce_resource.size).to eq resource
  end
end
