class UserService
  def initialize(user_params)
    @user_params = user_params
    @user = User.new(user_params.except(:image))
    @image = user_params[:image]
  end

  def signup
    ActiveRecord::Base.transaction do
      if @user.save
        attach_image if @image.present?
        return { user: @user, success: true, errors: [] }
      else
        return { errors: @user.errors.full_messages, success: false }
      end
    end
  rescue ActiveRecord::Rollback
    { errors: ['Image upload failed. User not created.'], success: false }
  end

  def login
    user = User.find_by(email: @user_params[:email])
    return { user: user, success: false, errors: ['Invalid email or password'] } unless user&.authenticate(@user_params[:password])

    { user: user, success: true, errors: [] }
  end

  private

  def attach_image
    @user.image.attach(@image)
    raise ActiveRecord::Rollback unless @user.image.attached?
  end

  def user_response(user)
    image_url = user.image.attached? ? url_for(user.image) : nil
    {
      token: encode_token(user_id: user.id),
      user: user.as_json.merge(image_url: image_url)
    }
  end
end
