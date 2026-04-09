class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers["Authorization"]

    token = header.split(" ").last if header

    decoded = JsonWebToken.decode(token)

    render json: { error: "Não autorizado" }, status: :unauthorized unless decoded
  end
end
