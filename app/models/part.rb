class Part < ActiveRecord::Base
  has_many :pictures

  validates_presence_of :name,  :message => t("part_model.error.name")
  
end
