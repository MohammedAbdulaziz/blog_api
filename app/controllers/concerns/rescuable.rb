module Rescuable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  end

  private

  def handle_standard_error(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end

  def handle_record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
end
