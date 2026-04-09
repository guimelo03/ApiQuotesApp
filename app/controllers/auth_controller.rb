class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [ :login ]

  def login
    if params[:email] == "admin@email.com" && params[:password] == "123456"
      token = JsonWebToken.encode(user_id: 1)

      render json: { token: token }
    else
      render json: { error: "Credenciais inválidas" }, status: :unauthorized
    end
  end
end
