class PicturesController < ApplicationController

  before_filter :get_part, :only => [:list]
  before_filter :build_header_content, :only => [:index, :list]

  def index
    @pictures = Picture.approved.paginate(
      :page => params[:page],
      :per_page => Constant::LARGE_PER_PAGE_ELEMENTS,
      :conditions => [" type_id = ? ", Picture::PICTURE])
  end

  def list
    @pictures = Picture.approved.paginate(
      :page => params[:page],
      :per_page => Constant::LARGE_PER_PAGE_ELEMENTS,
      :conditions => [" type_id = ? AND part_id = ? ", Picture::PICTURE, params[:id]])
    render :template => 'pictures/index'
  end

  def list_new
    @title = t("picture_controller.list_new.title")
    @page_keywords = t("picture_controller.list_new.keywords")
    @page_description = t("picture_controller.list_new.description")
    @content_text = t("header_info.list_new_pictures")
    index
  end

  def new
    @page_keywords = t("layout.new_picture_keywords")
    @page_description = t("layout.new_picture_description")
    @content_text = t("header_info.new_picture")
    @picture = Picture.new(params[:picture])
  end

  def create
    new
    @picture.subject ||= ''
    @picture.part_id = params[:part_id]
    @picture.type_id = Picture::PICTURE
    @picture.is_approved = false
    if @picture.save
      flash[:notice] = t("notice.sended_to_premoderation")
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end

  def show
    @picture = Picture.find(params[:id])
    @page_keywords = t("part_names.#{@picture.part.id}", :default => @picture.part.name)  + ', ' +
      t("picture_view.show_keywords")
    @page_description = picture_subject_for_default_locale(@picture, {:with_comma => true}) + 
      t("part_names.#{@picture.part.id}", :default => @picture.part.name)  + ', ' +
      t("picture_view.show_description")
  end

  private

  def get_part
    @part = Part.find(params[:id]) # params[:id] = params[:part_id]
  end

  def build_header_content
    if (params[:page].blank? || (params[:page] == '1'))
      @content_text = (@part ? t("part_contents.#{@part.id}", :default => @part.content) : t("header_info.index_welcome"))
    end
  end

end
