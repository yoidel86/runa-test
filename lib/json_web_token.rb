# lib to encode and decode token
class JsonWebToken
  class << self
    ##
    # :singleton-method:
    # Se encarga de crear el token de autenticacion y dejarlo registrado
    # por el tiempo especificado
    # ==== Example:
    #   JsonWebToken.encode(user.id,2.hours.from_now)
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
    ##
    # :singleton-method:
    # Se encarga de decodificar el token de autenticacion el cual contiene el id del usuario
    # por el tiempo especificado cuando se creo
    # ==== Example:
    #   userid = JsonWebToken.decode(token)
    def decode(token)
      if token
        body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        HashWithIndifferentAccess.new body
      else
        false
      end
    end
  end
end