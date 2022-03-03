# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  
  describe 'GET /api/v1/questions/:question_id/answers(action index)' do
    let(:user) { create(:user) }
    let(:question) {create(:question_factory, user: user)}
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }
    
    it_behaves_like 'API authorizable'
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      
      before do
        do_request(method, api_path, params: {question_id: question.id, access_token: access_token.token },
                                              headers: headers)
      end
      
      it_behaves_like 'Status be_successful'
      
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { json['questions'].first['answers']  }
        let(:resource) { answers.size }
      end
      
      it_behaves_like 'Return public fields' do
        let(:attributes) { %w[id body created_at updated_at] }
        let(:response_resource) { json['questions'].first['answers'].first }
        let(:resource) { answers.first }
      end
    end
  end
  
  describe 'GET /api/v1/answers/:id(action show)' do
    let(:user) { create(:user) }
    let(:question) { create(:question_factory, user: user) }
    let(:answer) { create(:answer, :with_file, question: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:answer_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }
    let(:access_token) { create(:access_token) }
    
    it_behaves_like 'API authorizable'
    
    before do
      do_request(method, api_path, params: { question_id: question.id, access_token: access_token.token },
        headers: headers)
    end
    
    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
    
    it_behaves_like 'Status be_successful'
    
    it_behaves_like 'Return public fields' do
      let(:attributes) { %w[id body created_at updated_at] }
      let(:response_resource) { answer_response }
      let(:resource) { answer }
    end
    
    context 'Comments' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { answer_response['comments'] }
        let(:resource) { answer.comments.size }
      end
    end
    
    context 'Links' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { answer_response['links'] }
        let(:resource) { answer.links.size }
      end
    end
    
    context 'Files' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { answer_response['files'] }
        let(:resource) { answer.files.size }
      end
    end
  end
end
