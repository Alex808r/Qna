# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    # context 'unauthorized' do
    #   it 'returns 401 status if there is no access_token' do
    #     get '/api/v1/questions', headers: headers
    #     expect(response.status).to eq 401
    #   end
    #
    #   it 'returns 401 status if access_token invalid' do
    #     get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question_factory, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status be_successful'

      # it 'returns 200 status' do
      #   expect(response).to be_successful
      # end

      # it 'returns list of question' do
      #   expect(json['questions'].size).to eq 2
      # end

      # it 'returnes all public fields' do
      #   %w[id title body created_at updated_at].each do |attr|
      #     expect(question_response[attr]).to eq question.send(attr).as_json
      #   end
      # end

      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { json['questions'] }
        let(:resource) { questions.size }
      end

      it_behaves_like 'Return public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:response_resource) { question_response }
        let(:resource) { question }
      end

      it 'contrains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contrains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        # it 'returns list of answer' do
        #   expect(question_response['answers'].size).to eq 3
        # end
        #
        # it 'returnes all public fields' do
        #   %w[id title user_id created_at updated_at].each do |attr|
        #     expect(answer_response[attr]).to eq answer.send(attr).as_json
        #   end
        # end

        it_behaves_like 'Return list of objects' do
          let(:responce_resource) { question_response['answers'] }
          let(:resource) { question.answers.size }
        end

        it_behaves_like 'Return public fields' do
          let(:attributes) { %w[id body user_id created_at updated_at] }
          let(:response_resource) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end
end
