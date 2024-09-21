class ApplicationController < ActionController::API
  include Authentication
  include Rescuable

  private

  def authorize_owner(record)
    render json: { message: 'Not authorized' }, status: :unauthorized unless record.user_id == @current_user.id
  end
end
