##
# Controladora encargada de manejar las peticiones de la Api de la aplicacion
# para poder responder las peticiones el usuario debera estar autenticado
# y para todas las peticiones verificara que es administrador exceptuando para la
# peticion api/my_reports que retornara los reportes de los usuarios no administradores
class ApiController < ApplicationController
  before_action :validate_admin, except: [:my_reports,:save_report]
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
  # Endpoint encargado de retornar los logs de un usuario especifico solicitado por un administrador en el rango de tiempo definido
  # @params [user_id[,start_date,end_date]]
  # @return [json] con los registros de usuario en el intervalo especifico, de ser invalido el registro retorna el error causado
  def user_logs
    if params[:user_id]
      start_date = Date.new
      start_date = params[:start_date].to_date if params[:start_date]
      end_date = Date.tomorrow
      end_date = params[:end_date].to_date if params[:end_date]
      @logs = param_user.logs.where(date: start_date..end_date) unless param_user.nil?
    end
    render 'api/logs.json'
  end
  ##
  # Endpoint encargado de retornar los logs de los usuarios que han registrado entrada en el dia actual pero no salida
  # @params
  # @return [json] con los registros de los usuarios , de ser invalida la petición retorna el error causado
  def logged_users
    @logs = Log.includes(:user).where(date: Date.today).where(timeout: nil)
    render 'api/user_log.json'
  end
  ##
  # Endpoint encargado de retornar los logs de los usuarios que no han registrado entrada en el dia actual
  # @params
  # @return [json] con los registros de los usuarios , de ser invalida la petición retorna el error causado
  def not_logged_users
    @users = User.where.not(id: Log.select(:user_id).where(date: Date.today))
    render 'api/users.json'
  end
  ##
  # Endpoint encargado de retornar los logs de los usuarios que se le registraron entrada y salida en el dia actual
  # @params
  # @return [json] con los registros de los usuarios , de ser invalida la petición retorna el error causado
  def day_logged_users
    @logs = Log.includes(:user).where(date: Date.today).where.not(timeout: nil)
    render 'api/user_log.json'
  end
  ##
  # Endpoint encargado de retornar los usuarios del sistema
  # @params
  # @return [json] con los usuarios del sistema , de ser invalida la petición retorna el error causado
  def users
    @users = User.includes(:logs).all
    render 'api/users.json'
  end
  ##
  # Endpoint encargado de registrar reporte generado a un usuario del sistema
  # Si el usuario es administrado le puede generar reporte a cualquier otro usuario
  # de lo contrario solo se puede generar reporte a si mismo
  # @params [user_id[,start_date,end_date]]
  # @return [json] con el reporte generado , de ser invalida la petición retorna el error causado

  def save_report
    if @current_user.isadmin
      @logs = param_user.logs.where(date: params[:start_date].to_date..params[:end_date].to_date) unless param_user.nil?
      @report = Reporte.create(generated_by:@current_user.id,date:Date.today,user_id:param_user.id,from:params[:start_date],to:params[:end_date],result:@logs.as_json)
    else
      @logs = @current_user.logs.where(date: params[:start_date].to_date..params[:end_date].to_date)
      @report = Reporte.create(generated_by:@current_user.id,date:Date.today,user_id:@current_user.id,from:params[:start_date],to:params[:end_date],result:@logs.as_json)
    end
    if @report.save
      return render 'api/report.json'
    else
      return render json: { errors: @report.errors.full_messages }, status:200
    end
  end
  ##
  # Endpoint encargado de retornar los reportes generado al usuario especificado por parametro
  # @params [user_id]
  # @return [json] con los usuarios del sistema , de ser invalida la petición retorna el error causado
  def get_user_reports
    @reports =param_user.reportes
    render json:@reports
  end
  ##
  # Endpoint encargado de retornar todos los reportes generados
  # @todo Paginar la petición
  # @return [json] con todos los reportes del sistema , de ser invalida la petición retorna el error causado
  def reports
    @reports =Reporte.includes(:user).all
    render 'api/reports.json'
  end
  ##
  # Endpoint encargado de eliminar reporte generado en el sistema a traves del id recibido por parametro
  # @params [report_id]
  # @return [json] indicando el exito de la operación , de ser invalida la petición retorna el error causado
  def remove_report
    if params[:report_id]
      report  = Reporte.find(params[:report_id])
      if report
        report.destroy
        return render json: "{success:true}",status: 200
      end
    end
      render json: "{errors:'reporte no encontrado'}",status: 412
  end

  ##
  # Endpoint encargado de eliminar usuario el sistema a traves del id recibido por parametro
  # @params [user_id]
  # @return [json] indicando el exito de la operación , de ser invalida la petición retorna el error causado
  def remove_user
    if param_user
      param_user.destroy
      render json:"{success:true}"
    end
  end
  ##
  # Endpoint encargado de obtener los reportes del usuario actual segun la utenticacion usada
  # Todos los usuarios autenticados tienen acceso a este endpoint
  # @return [json] con los reportes del usuario actual , de ser invalida la petición retorna el error causado

  def my_reports
    @reports =@current_user.reportes
    render json:@reports
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
  private
  def param_user
    if params[:user_id]
      user = User.find(params[:user_id])
      return user unless user.nil?
    end
    render json: { errors: 'user not found', status: 412 }
    return false
  end

  ##
  # valida que el usuario actual se administrador
  # @return [bool] con la validacion de que el usuario
  def validate_admin
    if @current_user.nil? || !@current_user.isadmin
      return render json: { error: 'Not Authorized' }, status: 401 unless @current_user.isadmin
    end
  end
end
