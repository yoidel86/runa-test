##
# Controladora para funcionar como cliente de la api
class FrontController < ActionController::Base
  before_action :authenticate_request
  skip_before_action :authenticate_request, only: [:login]
  attr_reader :current_user

  def index
    @user_name = @current_user.name
    if !@current_user.isadmin
     return render 'front/index_user'
    end
  end

  def login; end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    redirect_to '/' unless @current_user
  end
end
