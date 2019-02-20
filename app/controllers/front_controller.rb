class FrontController < ActionController::Base
  before_action :authenticate_request
  skip_before_action :authenticate_request, only: [:login]
  attr_reader :current_user

  def index
    @user_name = @current_user.name
  end

  def login; end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    redirect_to '/' unless @current_user
  end
end
