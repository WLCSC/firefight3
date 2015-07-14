class SessionController < ApplicationController
  def create
      if u = User.authenticate(params[:username], params[:password])
          session[:udn] = u.dn.to_s
          flash[:notice] = "Welcome, #{u.nice_name}"
      else
          flash[:error] = "Login failed."
      end
      redirect_to root_path
  end

  def destroy
      session.delete :udn
      redirect_to root_path
  end

  def flashtest
    flash[:notice] = "Successfully created..."
    flash[:error] = "Successfully created..."
    flash[:alert] = "Successfully created..."
    flash[:success] = "Successfully created..."
    redirect_to root_path
  end
end
