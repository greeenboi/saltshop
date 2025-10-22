class SessionsController < ApplicationController
  def create
    raw_login = params[:username] || params.dig(:session, :username) || params[:login]
    password = params[:password] || params.dig(:session, :password)

    if raw_login.blank? || password.blank?
      flash.now[:alert] = "Username/email and password are required"
      render :new, status: :unprocessable_entity and return
    end

    login = raw_login.to_s.strip.downcase
    user = User.where("LOWER(username) = :v OR LOWER(email) = :v", v: login).first

    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      Rails.logger.info "Login failed for #{login}; params (filtered): #{params.except(:password, :authenticity_token).to_unsafe_h}"
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
