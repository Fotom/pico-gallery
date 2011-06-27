class Admins::PicturesController < CommonAdminsController
  layout 'admins'

  def index
    redirect_to :action => "list"
  end

  def list
    @allowed_actions = {:destroy => true, :edit => true, :show => true}
    @pictures = Picture.approved.paginate(
      :page => params[:page])
  end

  def list_users
    @allowed_actions = {:destroy => true, :approve => true, :show => true}
    @pictures = Picture.not_approved.paginate(
      :page => params[:page])
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def new
    @picture = Picture.new(params[:picture])
    @parts = Part.find(:all, :order => 'order_number')
  end

  def create
    new
    @picture.part_id = params[:part_id]
    @picture.type_id = params[:type_id] || Picture::PICTURE
    @picture.is_approved = true
    if @picture.save
      flash[:notice] = t("notice.picture_created")
      redirect_to :action => "list"
    else
      render :action => "new"
    end
  end

  def edit
    @parts = Part.find(:all, :order => 'order_number')
    @picture = Picture.find(params[:id])
  end

  def update
    edit
    @picture.part_id = params[:part_id]
    @picture.type_id = params[:type_id] || Picture::PICTURE
    params[:picture][:photo] = @picture.photo if params[:picture][:photo].blank?
    if @picture.update_attributes(params[:picture])
      flash[:notice] = t("notice.picture_edited")
      redirect_to :action => "list"
    else
      render :action => "edit"
    end
  end

  def destroy
    begin
      picture = Picture.find(params[:id])
      picture.destroy
      flash[:notice] = t("notice.picture_deleted")
    rescue
      flash[:error] = t("error.picture_deleted")
    end
    redirect_to request.referer
  end

  def approve
    begin
      picture = Picture.find(params[:id])
      picture.approve
      flash[:notice] = t("notice.picture_approved")
    rescue
      flash[:error] = t("error.picture_approved")
    end
    redirect_to request.referer
  end

end
