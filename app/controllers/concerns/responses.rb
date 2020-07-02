module Responses
  extend ActiveSupport::Concern
  
  def success_response(data:, serializer:, status: :ok)
    json = {
      success: true,
      data: serializer.new(data)
    }

    render json: json, status: status and return
  end

  def array_success_response(data:, serializer:, status: :ok)
    json = {
      success: true,
      data: data.map { |item| serializer.new(item) }
    }

    render json: json, status: status and return
  end

  def error_response(errors:, status: :unprocessable_entity)
    json = {
      success: false,
      errors: errors
    }

    render json: json, status: status and return
  end
end