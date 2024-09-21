require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  let(:user) { create(:user) }
  let!(:tag) { create(:tag) }
  let(:blog_post) { create(:post, user: user, tags: [tag]) }  # Renamed here
  let(:headers) { { 'Authorization' => "Bearer #{generate_token(user)}" } }

  describe 'POST /posts/:post_id/comments' do
    let(:valid_attributes) { attributes_for(:comment) }

    context 'when request is valid' do
      it 'creates a new comment' do
        post "/posts/#{blog_post.id}/comments", params: { comment: valid_attributes }, headers: headers  # Updated here
        expect(response).to have_http_status(:created)
        expect(json['body']).to eq(valid_attributes[:body])
      end
    end

    context 'when request is invalid' do
      it 'returns an error when body is blank' do
        invalid_attributes = { comment: { body: '' } }
        post "/posts/#{blog_post.id}/comments", params: invalid_attributes, headers: headers  # Updated here
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Body can't be blank")
      end
    end
  end

  describe 'PUT /posts/:post_id/comments/:id' do
    let!(:comment) { create(:comment, post: blog_post, user: user) }  # Updated here
    let(:valid_attributes) { { comment: { body: 'Updated comment.' } } }

    context 'when user is the owner' do
      it 'updates the comment' do
        put "/posts/#{blog_post.id}/comments/#{comment.id}", params: valid_attributes, headers: headers  # Updated here
        expect(response).to have_http_status(:ok)
        expect(json['body']).to eq(valid_attributes[:comment][:body])
      end
    end

    context 'when user is not the owner' do
      let(:other_user) { create(:user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{generate_token(other_user)}" } }

      it 'returns an unauthorized error' do
        put "/posts/#{blog_post.id}/comments/#{comment.id}", params: valid_attributes, headers: other_headers  # Updated here
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when request is invalid' do
      it 'returns an error when body is blank' do
        invalid_attributes = { comment: { body: '' } }
        put "/posts/#{blog_post.id}/comments/#{comment.id}", params: invalid_attributes, headers: headers  # Updated here
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Body can't be blank")
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    let!(:comment) { create(:comment, post: blog_post, user: user) }  # Updated here

    context 'when user is the owner' do
      it 'deletes the comment' do
        expect {
          delete "/posts/#{blog_post.id}/comments/#{comment.id}", headers: headers  # Updated here
        }.to change(Comment, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not the owner' do
      let(:other_user) { create(:user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{generate_token(other_user)}" } }

      it 'returns an unauthorized error' do
        delete "/posts/#{blog_post.id}/comments/#{comment.id}", headers: other_headers  # Updated here
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
