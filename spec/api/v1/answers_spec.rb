# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers(action index)' do
    let(:user) { create(:user) }
    let(:question) { create(:question_factory, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before do
        do_request(method, api_path, params: { question_id: question.id, access_token: access_token.token },
                                     headers: headers)
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Return list of objects' do
        let(:responce_resource) { json['questions'].first['answers'] }
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

  describe 'POST /api/v1/questions/:question_id/answers(action create)' do
    let(:user) { create(:user) }
    let(:question) { create(:question_factory, user: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        post api_path, params: { question: question,
                                 user: user,
                                 answer: attributes_for(:answer),
                                 access_token: access_token.token }
      end

      context 'with valid attributes' do
        it 'create a new answer' do
          expect(Answer.count).to eq 1
        end

        # it 'with valid attributes second version' do
        #   expect do
        #     post api_path, params: { question: question,
        #                              user: user,
        #                              answer: attributes_for(:answer),
        #                              access_token: access_token.token }
        #   end.to change(Answer  , :count).by(1)
        # end

        it 'return status successful' do
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          { question: question,
            answer: attributes_for(:answer, :invalid),
            access_token: access_token.token }
        end

        it 'does not create question' do
          expect { post api_path, params: params }.to_not change(Answer, :count)
        end

        before { post api_path, params: params }

        it 'return status unprocessable entity' do
          expect(response.status).to eq 422
        end

        it 'return errors' do
          expect(response.body).to match(/errors/)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id(action update)' do
    let(:author) { create(:user) }
    let(:question) { create(:question_factory, user: author) }
    let(:answer) { create(:answer, body: 'MyAnswer', question: question, user: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    question: question,
                                    answer: { title: 'API title', body: 'API body' },
                                    access_token: access_token.token }
        end

        it_behaves_like 'Status be_successful'

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload

          expect(answer.title).to eq 'API title'
          expect(answer.body).to eq 'API body'
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    question: question,
                                    answer: attributes_for(:answer, :invalid),
                                    access_token: access_token.token }
        end

        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq 'MyAnswer'
        end

        it 'return status unprocessable entity' do
          expect(response.status).to eq 422
        end

        it 'return errors' do
          expect(response.body).to match(/errors/)
        end
      end

      context 'Not Author answer' do
        let(:not_author) { create(:user) }
        let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }

        before do
          patch api_path, params: { id: answer,
                                    question: question,
                                    answer: attributes_for(:answer, :invalid),
                                    access_token: not_author_access_token.token }
        end

        it 'not changes question attirbutes' do
          answer.reload

          expect(answer.body).to eq 'MyAnswer'
        end

        it 'returns 302 status' do
          expect(response.status).to eq 302
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id(action destroy)' do
    let(:author) { create(:user) }
    let(:question) { create(:question_factory, user: author) }
    let!(:answer) { create(:answer, question: question, user: author) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      before do
        delete api_path, params: { id: answer, access_token: access_token.token }
      end

      it_behaves_like 'Status be_successful'

      it 'deletes the answer' do
        expect(Answer.count).to eq 0
      end

      it 'returns successful message' do
        expect(json['messages']).to include('Your answer successfully deleted')
      end
    end

    context 'not authorized' do
      let(:not_author) { create(:user) }
      let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }
      let(:params) { { id: answer, question: question, access_token: not_author_access_token.token } }
      subject { delete api_path, params: params, headers: headers }

      # before do
      #   delete api_path, params: params, headers: headers
      # end

      it 'cannot delete the answer' do
        expect { subject }.to_not change(Question, :count)
        # expect(Answer.count).to eq 1
      end

      it 'returns status 403' do
        subject
        expect(response.status).to eq 403
      end
    end

    context 'admin can delete' do
      let(:admin) { create(:user, :admin) }
      let(:admin_access_token) { create(:access_token, resource_owner_id: admin.id) }
      let(:params) { { id: answer, question: question, access_token: admin_access_token.token } }
      subject { delete api_path, params: params, headers: headers }

      it 'delete the question' do
        expect { subject }.to change(Answer, :count)
      end

      it 'returns successful message' do
        subject
        expect(json['messages']).to include('Your answer successfully deleted')
      end
    end
  end
end
