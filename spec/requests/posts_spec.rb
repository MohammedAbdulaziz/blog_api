require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_token(user)}" } }

  describe 'GET /posts' do
    let!(:post) { create(:post, user: user) }

    it 'returns all posts' do
      get '/posts', headers: headers
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(1)
    end
  end

  describe 'POST /posts' do
    let(:tag) { create(:tag) }
    let(:valid_attributes) { attributes_for(:post, user: user).merge(tag_ids: [tag.id]) }

    context 'when request is valid' do
      it 'creates a new post' do
        post '/posts', params: { post: valid_attributes }, headers: headers
        expect(response).to have_http_status(:created)
        expect(json['title']).to eq(valid_attributes[:title])
      end
    end

    context 'when request is invalid' do
      it 'returns an error' do
        post '/posts', params: { post: { title: '', body: '' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /posts/:id' do
    let!(:post) { create(:post, user: user) }

    context 'when user is the author' do
      let(:valid_attributes) { { post: { title: 'Updated Title' } } }

      it 'updates the post' do
        put "/posts/#{post.id}", params: valid_attributes, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json['title']).to eq('Updated Title')
      end
    end

    context 'when user is not the author' do
      let(:other_user) { create(:user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{generate_token(other_user)}" } }

      it 'returns an unauthorized error' do
        put "/posts/#{post.id}", params: { post: { title: 'Updated Title' } }, headers: other_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    let!(:post) { create(:post, user: user) }

    it 'deletes the post' do
      expect {
        delete "/posts/#{post.id}", headers: headers
      }.to change(Post, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
