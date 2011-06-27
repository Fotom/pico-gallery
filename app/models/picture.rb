class Picture < ActiveRecord::Base

  named_scope :approved, :conditions => " COALESCE(is_approved,0) != 0 ", :order => 'created_at desc'
  named_scope :not_approved, :conditions => " COALESCE(is_approved,0) = 0 ", :order => 'created_at desc'

  cattr_reader :per_page
  @@per_page = Constant::DEFAULT_PER_PAGE_ELEMENTS

  has_attached_file :photo,
    :styles => {
      :thumb  => "160x160>" },
    :path => ":rails_root/public/images/:class/:attachment/:id/:style_:basename.:extension",
    :url => "/images/:class/:attachment/:id/:style_:basename.:extension"

  belongs_to :part
  
  validates_presence_of :part_id, :message => t("picture_model.error.part_id")
  validates_presence_of :photo_file_name, :message => t("picture_model.error.photo_file_name")

  # types
  PICTURE = 1
  AVATAR  = 2
  FLASH   = 3

  PICTURE_TYPES = [PICTURE, AVATAR, FLASH]

  PICTURE_TYPE_DESCRIPTIONS = {
    PICTURE => t("picture_model.types.picture"),
    AVATAR  => t("picture_model.types.avatar"),
    FLASH   => t("picture_model.types.flash")
  }

  def approve
    self.is_approved = true
    self.save!
  end

end
