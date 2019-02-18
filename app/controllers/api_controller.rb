class ApiController < ApplicationController
  before_action :validate_is_admin

  def login
    if(params[:user_id])
      user = User.find(params[:user_id])
      if !user.nil?
        @log = Log.new(date:Date.today,timein:Time.current,user_id:user.id,created_by:@current_user.id)
        if @log.save
         return render json: @log, status: :created
        else
         return render json: { errors: @log.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
    render json: {errors:"user not found"}
  end

  def logout
    if(params[:user_id])
      user = User.find(params[:user_id])
      if(user)
        @log = user.logs.find(params[:lob_id])
        if(@log)
          @log.timeout = Time.current
          if(@log.save)
            return render json: @log, status: :Accepted
          else
            return render json: { errors: @log.errors.full_messages },
                          status: :unprocessable_entity
          end
        end
        return render json: {errors:"user not found",
                             status: 412}
      end
    end
    render json: {errors:"user not found",
                  status: 412}
  end

  def userlogs
    if(params[:user_id])
     user = User.find_each(params[:user_id])
      if !user.nil?
        @logs = user.logs
      end
    end
    render 'api/logs.json'
  end

  def users
    @users = User.includes(:logs).all
    render 'api/users.json'
  end

  private

  def validate_is_admin
    if @current_user.nil?|| !@current_user.isadmin
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user.isadmin
    end
  end

end
