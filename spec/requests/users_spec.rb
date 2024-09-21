require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /signup' do
    let(:valid_attributes) { attributes_for(:user) }

    let(:invalid_attributes) do
      { user: { name: '', email: '', password: '', image: '' } }
    end

    context 'when request is valid' do
      it 'creates a new user and returns JWT token' do
        post '/signup', params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(json['token']).to be_present
      end
    end

    context 'when request is invalid' do
      it 'returns an error' do
        post '/signup', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)    
        expect(json['errors']).to include("Password can't be blank")
        expect(json['errors']).to include("Email can't be blank")
      end
    end    
  end

  describe 'POST /login' do
    let(:user) { create(:user, password: 'password') }

    context 'when credentials are valid' do
      it 'returns JWT token' do
        post '/login', params: { user: { email: user.email, password: 'password' } }
        expect(response).to have_http_status(:ok)
        expect(json['token']).to be_present
      end
    end

    context 'when credentials are invalid' do
      it 'returns an error' do
        post '/login', params: { user: { email: user.email, password: 'wrong_password'} }
        expect(response).to have_http_status(:unauthorized)
        expect(json['errors']).to include("Invalid email or password")
      end
    end
  end
end
