class UsersController < ApplicationController
  before_action :logged_in
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  private
    def logged_in
      if session[:user_id].nil?
        flash[:result_text] = "You must be logged in to do that"
        redirect_to root_path
      end
    end
end
