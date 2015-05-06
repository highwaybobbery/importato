class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user= auth_hash
    session[:auth_hash] = auth_hash
  end

  def current_user
    if current_user = session[:auth_hash]
      Rails.logger.info 'Current User is set'
    else
      Rails.logger.info 'Current User is not set'
    end
    current_user
  end

  def authenticate_user!
    if !current_user
      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    end
  end

end
