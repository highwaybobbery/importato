class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to new_uplaod_path
    else
      redirect_to '/auth/github'
    end
  end

  def create
    self.current_user = auth_hash
    redirect_to root_path
  end

  def destroy
    session.destroy
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
