class UsersController < ApplicationController
  include Authentication
  before_action :authorized, except: [:signup, :login]

  def signup
    service_response = UserService.new(user_params).signup

    if service_response[:success]
      render json: user_response(service_response[:user]), status: :created
    else
      render json: { errors: service_response[:errors] }, status: :unprocessable_entity
    end
  end

  def login
    service_response = UserService.new(login_params).login

    if service_response[:success]
      render json: user_response(service_response[:user]), status: :ok
    else
      render json: { errors: service_response[:errors] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def user_response(user)
    image_url = user.image.attached? ? url_for(user.image) : nil
    {
      token: encode_token(user_id: user.id),
      user: user.as_json.merge(image_url: image_url)
    }
  end
end
