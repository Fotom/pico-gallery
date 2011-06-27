class Admins::PartsController < CommonAdminsController
  layout 'admins'

  def index
    redirect_to :action => "list"
  end

  def list
    @parts = Part.find(:all, :order => 'order_number')
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(params[:part])
    if @part.save
      flash[:notice] = t("notice.part_created")
      redirect_to :action => "list"
    else
      render :action => "new"
    end
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    if @part.update_attributes(params[:part])
      flash[:notice] = t("notice.part_edited")
      redirect_to :action => "list"
    else
      render :action => "edit"
    end
  end

  def destroy
    begin
      part = Part.find(params[:id])
      part.destroy
      flash[:notice] = t("notice.part_deleted")
    rescue
      flash[:error] = t("error.part_deleted")
    end

    redirect_to :action => "list"
  end

end
