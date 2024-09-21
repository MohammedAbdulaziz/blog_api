module AuthHelper
  def generate_token(user)
    JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
  end
end