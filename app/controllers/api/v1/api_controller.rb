##
# Controladora encargada de manejar las peticiones de la Api de la aplicacion
# para poder responder las peticiones el usuario debera estar autenticado
# y para todas las peticiones verificara que es administrador exceptuando para la
# peticion api/my_reports que retornara los reportes de los usuarios no administradores
class ApiController < ApplicationController
  before_action :validate_admin
  ##
  # Endpoint encargado de registrar la entrada de un usuario por parte de un administrador
  # @return [json] con la informacion del registro actual, de ser invalido el registro retorna el error causado
  def login
    @log = Log.new(date: Date.today, timein: Time.current, user_id: param_user.id, created_by: @current_user.id)
    if @log.save
      render json: @log, status: :created
    else
      render json: { errors: @log.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  ##
  # Endpoint encargado de registrar la salida de un usuario por parte de un administrador
  # @return [json] con la informacion del registro actual, de ser invalido el registro retorna el error causado
  def logout
    @log = param_user.logs.find(params[:log_id])
    if @log
      @log.timeout = Time.current
      if @log.save
        render json: @log, status: 200
      else
        render json: { errors: @log.errors.full_messages },
               status: :unprocessable_entity
      end
      return
    end
    render json: { errors: 'user did not logged before', status: 412 }
  end


  ##
  # Endpoint encargado de obtener algunos valores estadisticos para mostrar en el dashboard del sistema
  # @todo Ampliar la informacion del mismo, ej:Horas promedio por dia,trabajador mas trabaja por dia ...
  # @return [json] con los algunos datos estadisticos , de ser invalida la petición retorna el error causado
  def dashboard
    @total_logs = Log.all.count
    @logs_in_not_out = Log.where.not(timein: nil).where(timeout:nil).count
    @logs_today = Log.where(date: Date.today).count*100.0/User.all.count
    @logs_users = User.all.count
    @logs_in_and_out = Log.where.not(timein: nil).where.not(timeout:nil).count
    @logs_by_user = Log.select(:user_id,'count(*)').group(:user_id).as_json
    render 'api/dashboard'
  end

end
