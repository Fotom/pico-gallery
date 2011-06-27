class ApplicationController < ActionController::Base

  before_filter :set_content_type
  before_filter :get_part_names
  before_filter :get_newest_photo
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_locale_from_url

  private

  def get_newest_photo
    pictures = Picture.approved.find(:all, :limit => 30)
    @newest_pictures = pictures.sort_by{rand()}.values_at(0,1,2)
  end

  def get_part_names
    return if params[:editor] == "article_content_editor" || !params[:wysihat_file].blank?
    @parts = Part.find(:all, :order => 'order_number')
  end

  def set_content_type
    headers["Content-Type"] = "text/html; charset=utf-8"
    true
  end

  def require_admin
    if !is_admin?
      redirect_to '/'
      return false
    end
    true
  end

  def is_admin?
    session[:is_admin] && (session[:is_admin] == 'admins session') ? true : false
  end

end
