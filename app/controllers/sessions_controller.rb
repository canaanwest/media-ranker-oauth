class SessionsController < ApplicationController
  def login_form
  end

  def login
    username = params[:username]
    if username and user = User.find_by(user: username)
      session[:user_id] = user.id
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing user #{user.username}"
    else
      user = User.new(username: username)
      if user.save
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not log in"
        flash.now[:messages] = user.errors.messages
        render "login_form", status: :bad_request
        return
      end
    end
    redirect_to root_path
  end

  def create
    @auth_hash = request.env['omniauth.auth']
    ap @auth_hash

    @user = User.find_by(uid: @auth_hash['uid'], provider: @auth_hash['provider'])

    if @user
      session[:user_id] = @user.id
      flash[:result_text] = "#{@user.name} has been logged in!"

    else
      @user = User.new(uid: @auth_hash['uid'], provider: @auth_hash['provider'], name: @auth_hash['info']['nickname'], email: @auth_hash['info']['email'], username: @auth_hash['info']['nickname'])

      if @user.save
        session[:user_id] = @user.id
        flash[:result_text] = "#{@user.name} has been logged in!"

      else
        flash[:result_text] = "Unable to save user!"
      end
    end
    redirect_to root_path
  end


  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end

end
