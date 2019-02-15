class FrontController < ApplicationController
  skip_before_action :authenticate_request, :only => [:index]
  def index
  end
end
