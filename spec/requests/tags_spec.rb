require 'rails_helper'

RSpec.describe 'Tags API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_token(user)}" } }

  describe 'GET /tags' do
    let!(:tags) { create_list(:tag, 3) }

    it 'returns all tags' do
      get '/tags', headers: headers
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end

    it 'returns an empty array when no tags exist' do
      Tag.destroy_all
      get '/tags', headers: headers
      expect(response).to have_http_status(:ok)
      expect(json).to eq([])
    end
  end

  describe 'POST /tags' do
    let(:valid_attributes) { { tag: { name: 'New Tag' } } }

    context 'when request is valid' do
      it 'creates a new tag' do
        post '/tags', params: valid_attributes, headers: headers
        expect(response).to have_http_status(:created)
        expect(json['name']).to eq(valid_attributes[:tag][:name])
      end
    end

    context 'when request is invalid' do
      it 'returns an error when name is blank' do
        post '/tags', params: { tag: { name: '' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Name can't be blank")
      end

      it 'returns an error when name is too short' do
        post '/tags', params: { tag: { name: 'A' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Name is too short (minimum is 2 characters)")
      end
    end
  end

  describe 'PUT /tags/:id' do
    let!(:tag) { create(:tag) }
    let(:valid_attributes) { { tag: { name: 'Updated Tag' } } }

    context 'when request is valid' do
      it 'updates the tag' do
        put "/tags/#{tag.id}", params: valid_attributes, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json['name']).to eq('Updated Tag')
      end
    end

    context 'when request is invalid' do
      it 'returns an error when name is blank' do
        put "/tags/#{tag.id}", params: { tag: { name: '' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Name can't be blank")
      end

      it 'returns an error when tag does not exist' do
        put "/tags/999", params: valid_attributes, headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq("Record not found")
      end
    end
  end

  describe 'DELETE /tags/:id' do
    let!(:tag) { create(:tag) }

    context 'when tag exists' do
      it 'deletes the tag' do
        expect {
          delete "/tags/#{tag.id}", headers: headers
        }.to change(Tag, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when tag does not exist' do
      it 'returns a not found error' do
        delete "/tags/999", headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq("Record not found")
      end
    end
  end
end
