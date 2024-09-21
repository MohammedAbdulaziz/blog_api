module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authorized, except: [:signup, :login]
  end

  def authorized
    header = request.headers['Authorization']
    token = header.split(' ')[1] if header
    begin
      @decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = User.find(@decoded["user_id"])
    rescue JWT::DecodeError
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
