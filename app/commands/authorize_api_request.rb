# Comando que ejecuta la autorización del usuario a traves del
# Token de seguridad JWT que debe llegar en el header de la petición
# realizada a la Api
class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end
  # Retorna el usuario autorizado si encuentra el token de seguridad en el header de la peticion
  # de lo contrario el error usuario no autorizado
  #  # ==== Example:
  #   @user = AuthorizeApiRequest.call(request.headers).result
  def call
    user
  end

  private

  attr_reader :headers
  ##
  # Retorna el usuario segun el token recibido o en su defecto el error Token invalido
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Token invalido') && nil
  end
  ##
  # Decodifica el token recibido
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end
  ##
  # Extrae el token de la cabecera de la petición
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    errors.add(:token, 'Missing token')
    false
  end
end