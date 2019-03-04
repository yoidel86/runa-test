# Comando para ejecutar  la autenticacion del usuario
# Genera un JWT si las credenciales son validas
# de lo contrario genera un error de credenciales invalidas
class AuthenticateUser
  prepend SimpleCommand

  ##
  # Se encarga de autenticar el usuario en cuestion retornando el token generado
  # de ser satisfactoria la autenticacion
  # ==== Example:
  #   command = AuthenticateUser.call(user[:email], user[:password])
  #   if command.success?
  #     render json: { auth_token: command.result }
  #   end
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)
    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
