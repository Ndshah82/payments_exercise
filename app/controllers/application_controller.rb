class ApplicationController < ActionController::API
  include Responses
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end
end
