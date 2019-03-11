##
# Controladora encargada de manejar las peticiones de la Api de la aplicacion
# para poder responder las peticiones el usuario debera estar autenticado
# y para todas las peticiones verificara que es administrador exceptuando para la
# peticion api/my_reports que retornara los reportes de los usuarios no administradores
module Api::V1
  class ReportsController < ApplicationController
  before_action :validate_admin, except: [:my_reports,:save_report]

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
  # Endpoint encargado de obtener los reportes del usuario actual segun la utenticacion usada
  # Todos los usuarios autenticados tienen acceso a este endpoint
  # @return [json] con los reportes del usuario actual , de ser invalida la petición retorna el error causado
  def my_reports
    @reports =@current_user.reportes
    render json:@reports
  end

  end
end

