module Api::V1
  class UserController < ApplicationController

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
  end
end
