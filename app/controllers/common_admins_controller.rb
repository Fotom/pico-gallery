class CommonAdminsController < ApplicationController
  layout 'admins'
  before_filter :require_admin, :except => [:login, :login_set]

  def index
  end

  def login
  end

  def login_set
    if !params[:password].blank? && params[:password] == Constant.find_by_name('admin_password').value
      session[:is_admin] = 'admins session'
    else
      session[:is_admin] = nil
      render :action => 'login'
      return
    end
    redirect_to :controller => 'admins/parts', :action => 'index'
  end

end
