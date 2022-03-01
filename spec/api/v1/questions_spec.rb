# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  # let(:headers) do
  #   { 'CONTENT_TYPE' => 'application/json',
  #     'ACCEPT' => 'application/json' }
  # end

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions(action index)' do
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

  describe 'GET /api/v1/questions/:id(action show)' do
    let(:user) { create(:user) }
    let(:question) { create(:question_factory, :with_file, user: user) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:question_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API authorizable'

    before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

    it_behaves_like 'Status be_successful'

    it_behaves_like 'Return public fields' do
      let(:attributes) { %w[id title body created_at updated_at] }
      let(:response_resource) { question_response }
      let(:resource) { question }
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    context 'Answers' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { question_response['answers'] }
        let(:resource) { question.answers.size }
      end
    end

    context 'Comments' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { question_response['comments'] }
        let(:resource) { question.comments.size }
      end
    end

    context 'Links' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { question_response['links'] }
        let(:resource) { question.links.size }
      end
    end

    context 'Files' do
      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { question_response['files'] }
        let(:resource) { question.files.size }
      end
    end
  end

  describe 'POST /api/v1/questions(action create)' do
    let(:api_path) { '/api/v1/questions' }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'create a new question' do
          expect do
            post api_path, params: { question: attributes_for(:question_factory),
                                     access_token: access_token.token }
          end.to change(Question, :count).by(1)
        end

        it 'return status successful' do
          post api_path, params: { question: attributes_for(:question_factory), access_token: access_token.token }
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        it 'does not create question' do
          expect do
            post api_path, params: { question: attributes_for(:question_factory, :invalid),
                                     access_token: access_token.token }
          end.to_not change(Question, :count)
        end

        before do
          post api_path, params: { question: attributes_for(:question_factory, :invalid),
                                   access_token: access_token.token }
        end

        it 'return status unprocessable entity' do
          expect(response.status).to eq 422
        end

        it 'return errors' do
          expect(response.body).to match(/errors/)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions(action update)' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    let!(:question) { create(:question_factory, user: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:author_access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        before do
          patch api_path, params: { id: question,
                                    question: { title: 'new title API', body: 'new body API' },
                                    access_token: author_access_token.token }
        end

        it_behaves_like 'Status be_successful'

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'new title API'
          expect(question.body).to eq 'new body API'
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: question,
                                    question: attributes_for(:question_factory, :invalid),
                                    access_token: author_access_token.token }
        end
        it 'does not change question' do
          question.reload

          expect(question.body).to eq 'MyText'
        end

        it 'return status unprocessable entity' do
          expect(response.status).to eq 422
        end

        it 'return errors' do
          expect(response.body).to match(/errors/)
        end
      end

      context 'Not Author questions' do
        let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }

        before do
          patch api_path, params: { id: question,
                                    question: attributes_for(:question_factory),
                                    access_token: not_author_access_token.token }
        end

        it 'not changes question attirbutes' do
          question.reload

          expect(question.body).to eq 'MyText'
        end

        it 'returns 302 status' do
          expect(response.status).to eq 302
        end
      end
    end
  end
end
