# class para ser heredada que asegure la autorización y/o autenticación de la petición
class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  ##
  # valida que el usuario actual se administrador
  # @return [bool] con la validacion de que el usuario
  def validate_admin
    if @current_user.nil? || !@current_user.isadmin
      return render json: { error: 'Not Authorized' }, status: 401 unless @current_user.isadmin
    end
  end
  ##
  # Obtiene el usuario segun el id recibido por parametro
  # @return [User] si existe alguno, si no retorna el error de que el usuario no existe
  def param_user
    if params[:user_id]
      user = User.find(params[:user_id])
      return user unless user.nil?
    end
    render json: { errors: 'user not found', status: 412 }
    return false
  end
  private
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
