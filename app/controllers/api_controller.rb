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
  # Endpoint encargado de retornar los logs de un usuario especifico solicitado por un administrador
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

  def logged_users
    @logs = Log.includes(:user).where(date: Date.today).where(timeout: nil)
    render 'api/user_log.json'
  end

  def not_logged_users
    @users = User.where.not(id: Log.select(:user_id).where(date: Date.today))
    render 'api/users.json'
  end
  def day_logged_users
    @logs = Log.includes(:user).where(date: Date.today).where.not(timeout: nil)
    render 'api/user_log.json'
  end
  def users
    @users = User.includes(:logs).all
    render 'api/users.json'
  end
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
  def get_user_reports
    @reports =param_user.reportes
    render json:@reports
  end
  def reports
    @reports =Reporte.includes(:user).all
    render 'api/reports.json'
  end
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
  def remove_user
    if param_user
      param_user.destroy
      render json:"{success:true}"
    end
  end
  def my_reports
    @reports =@current_user.reportes
    render json:@reports
  end


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

  # @return [bool]

  def validate_admin
    if @current_user.nil? || !@current_user.isadmin
      return render json: { error: 'Not Authorized' }, status: 401 unless @current_user.isadmin
    end
  end
end
